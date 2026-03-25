import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/data_service.dart';

/// A small offline-first catalog used by Apply/Pay/Services to keep UI stable.
///
/// Backend is optional: if it fails or times out we fall back to offline data.
class ServiceCatalogItem {
  final String name;
  final double price;

  /// Optional icon key (mapped in UI).
  final String iconKey;

  const ServiceCatalogItem({
    required this.name,
    required this.price,
    this.iconKey = 'receipt',
  });
}

class ServiceCatalogService {
  static final ServiceCatalogService _instance = ServiceCatalogService._internal();
  factory ServiceCatalogService() => _instance;
  ServiceCatalogService._internal();

  List<ServiceCatalogItem>? _cache;
  Future<List<ServiceCatalogItem>>? _inFlight;
  DateTime? _cacheTime;

  static const Duration _defaultTimeout = Duration(seconds: 4);
  static const Duration _cacheTtl = Duration(minutes: 10);

  static const List<String> _baseServices = [
    'Birth Certificate',
    'Death Certificate',
    'Marriage Certificate',
    'Income Certificate',
    'Caste Certificate',
    'Residence Certificate',
    'Passport Application',
    'Driving License',
    'Voter ID',
    'PAN Card',
    'Ration Card',
    'Property Tax',
  ];

  List<String> getSelectableServiceTitles() {
    final schemeTitles = DataService().getSchemes().map((s) => s.title).toList();
    final seen = <String>{};
    final result = <String>[];

    for (final s in _baseServices) {
      if (seen.add(s)) result.add(s);
    }
    for (final s in schemeTitles) {
      if (seen.add(s)) result.add(s);
    }
    return result;
  }

  ServiceCatalogItem _offlineItemFor(String serviceName) {
    // Offline kiosk fallback pricing.
    const defaultPrice = 100.0;

    // Lightweight icon key mapping to keep UI consistent.
    final name = serviceName.toLowerCase();
    String iconKey;
    if (name.contains('birth') || name.contains('death')) {
      iconKey = 'child_care';
    } else if (name.contains('income') || name.contains('property')) {
      iconKey = 'water_drop';
    } else if (name.contains('marriage')) {
      iconKey = 'bolt';
    } else if (name.contains('passport') || name.contains('license') || name.contains('driving')) {
      iconKey = 'storefront';
    } else if (name.contains('voter') || name.contains('pan') || name.contains('ration') || name.contains('caste')) {
      iconKey = 'home';
    } else {
      iconKey = 'receipt';
    }

    return ServiceCatalogItem(name: serviceName, price: defaultPrice, iconKey: iconKey);
  }

  Future<List<ServiceCatalogItem>> getServices({
    Duration timeout = _defaultTimeout,
    bool forceRefresh = false,
  }) async {
    final now = DateTime.now();
    if (!forceRefresh &&
        _cache != null &&
        _cacheTime != null &&
        now.difference(_cacheTime!) < _cacheTtl) {
      return _cache!;
    }

    if (_inFlight != null && !forceRefresh) {
      return _inFlight!;
    }

    _inFlight = _fetchServices(timeout: timeout).whenComplete(() {
      _inFlight = null;
    });

    _cache = await _inFlight!;
    _cacheTime = DateTime.now();
    return _cache!;
  }

  Future<List<ServiceCatalogItem>> _fetchServices({
    required Duration timeout,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/service-catalog/'))
          .timeout(timeout);

      if (response.statusCode != 200) {
        return _offlineServices();
      }

      final data = jsonDecode(response.body);
      if (data is! List) {
        return _offlineServices();
      }

      final backendByName = <String, ServiceCatalogItem>{};
      for (final raw in data) {
        if (raw is! Map) continue;
        final name = raw['name']?.toString().trim();
        if (name == null || name.isEmpty) continue;

        final price = double.tryParse(raw['base_price']?.toString() ?? '') ?? 0.0;
        final iconKey = raw['icon_name']?.toString() ?? 'receipt';
        // Only accept backend price if it is valid.
        if (price > 0) {
          backendByName[name] = ServiceCatalogItem(
            name: name,
            price: price,
            iconKey: iconKey,
          );
        }
      }

      // Keep the list identical to Apply dropdown order.
      final offlineTitles = getSelectableServiceTitles();
      if (offlineTitles.isEmpty) return _offlineServices();

      final merged = offlineTitles.map((title) {
        return backendByName[title] ?? _offlineItemFor(title);
      }).toList();

      return merged;
    } on TimeoutException {
      return _offlineServices();
    } catch (_) {
      return _offlineServices();
    }
  }

  List<ServiceCatalogItem> _offlineServices() {
    final titles = getSelectableServiceTitles();
    return titles.map(_offlineItemFor).toList();
  }

  /// Always-available offline services (no network).
  /// Useful as a timeout fallback to guarantee the UI never becomes blank.
  List<ServiceCatalogItem> getOfflineServices() => _offlineServices();
}

