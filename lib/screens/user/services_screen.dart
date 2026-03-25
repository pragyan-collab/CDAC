import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/kiosk_busy_overlay.dart';
import '../../widgets/skeleton/kiosk_skeleton_card.dart';
import '../../widgets/skeleton/kiosk_skeleton_list.dart';
import '../../services/service_catalog_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _currentIndex = 1;
  bool _isLoading = true;
  bool _isBusy = false;
  List<ServiceCatalogItem> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() => _isLoading = true);

    final catalog = ServiceCatalogService();
    try {
      final offlineFallback = catalog.getOfflineServices();

      final items = await Future.any<List<ServiceCatalogItem>>([
        catalog.getServices(timeout: const Duration(seconds: 4)),
        Future.delayed(
          const Duration(seconds: 6),
          () => offlineFallback,
        ),
      ]);

      if (!mounted) return;
      setState(() {
        _services = items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _services = catalog.getOfflineServices();
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Showing offline services')),
        );
      }
    }
  }

  Future<void> _runBusyNavigation(Future<void> Function() action) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 250));
        if (mounted) setState(() => _isBusy = false);
      }
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    if (_isBusy) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        _runBusyNavigation(
            () => SafeNavigation.navigateReplacementTo(AppRoutes.home));
        break;
      case 1:
        break;
      case 2:
        _runBusyNavigation(() => SafeNavigation.navigateReplacementTo(
            AppRoutes.schemesList));
        break;
      case 3:
        _runBusyNavigation(
            () => SafeNavigation.navigateReplacementTo(AppRoutes.newsList));
        break;
      case 4:
        _runBusyNavigation(
            () => SafeNavigation.navigateReplacementTo(AppRoutes.about));
        break;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'bolt':
        return Icons.bolt;
      case 'water_drop':
        return Icons.water_drop;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'home':
        return Icons.home;
      case 'child_care':
        return Icons.child_care;
      case 'storefront':
        return Icons.storefront;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildServiceCard(ServiceCatalogItem service) {
    final String name = service.name;
    final String iconName = service.iconKey;
    final double price = service.price;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor:
          AppConstants.primaryBlue.withOpacity(0.1),
          child: Icon(
            _getIcon(iconName),
            color: AppConstants.primaryBlue,
          ),
        ),
        onTap: _isBusy
            ? null
            : () => _runBusyNavigation(() async {
                  await SafeNavigation.navigateTo(
                    AppRoutes.apply,
                    arguments: {'service': name},
                  );
                }),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Fees: ₹${price.toStringAsFixed(0)}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: KioskSkeletonList(
          itemCount: 6,
          itemBuilder: (context, index) => const KioskSkeletonServiceCard(),
        ),
      );
    }

    if (_services.isEmpty) {
      return const Center(
        child: Text(
          'No services available right now.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(_services[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: SafeArea(
        child: KioskBusyOverlay(
          isBusy: _isBusy,
          message: 'Loading...',
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: AppConstants.pageBg,
                child: const Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}