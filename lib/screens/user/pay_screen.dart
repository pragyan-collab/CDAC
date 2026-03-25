import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/kiosk_busy_overlay.dart';
import '../../widgets/skeleton/kiosk_skeleton_card.dart';
import '../../services/service_catalog_service.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  bool _isBusy = false;
  bool _isLoading = true;

  List<ServiceCatalogItem> _services = [];
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
    });

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
        _selectedIndex = items.isNotEmpty ? 0 : -1;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _services = catalog.getOfflineServices();
        _selectedIndex = _services.isNotEmpty ? 0 : -1;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Showing offline service list'),
          ),
        );
      }
    }
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
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

  IconData _getIcon(String iconKey) {
    switch (iconKey) {
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

  Future<void> _onPayPressed() async {
    if (_selectedIndex < 0 || _selectedIndex >= _services.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service first'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
      return;
    }

    final service = _services[_selectedIndex];
    final amount = service.price;
    if (amount <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This service is not available for payment'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
      return;
    }

    await _runBusyAction(() async {
      await SafeNavigation.navigateTo(
        AppRoutes.payment,
        arguments: {
          'serviceName': service.name,
          'amount': amount,
          'applicationId': 'APP_${DateTime.now().millisecondsSinceEpoch}',
        },
      );
    });
  }

  Widget _buildServiceCard(ServiceCatalogItem service, int index) {
    final name = service.name;
    final iconName = service.iconKey;
    final price = service.price;
    final isSelected = index == _selectedIndex;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isBusy ? null : () => setState(() => _selectedIndex = index),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: AppConstants.primaryBlue.withOpacity(0.1),
            child: Icon(_getIcon(iconName), color: AppConstants.primaryBlue),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Fees: ₹$price',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? AppConstants.primaryBlue : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ServiceCatalogItem? selected = (_selectedIndex >= 0 &&
            _selectedIndex < _services.length)
        ? _services[_selectedIndex]
        : null;

    final canPay = selected != null && selected.price > 0.0;

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: KioskBusyOverlay(
        isBusy: _isBusy,
        message: 'Processing...',
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a Service',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? ListView.builder(
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return const KioskSkeletonServiceCard();
                          },
                        )
                      : _services.isEmpty
                          ? const Center(
                              child: Text(
                                'No services available. Please try again later.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppConstants.textMedium),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _services.length,
                              itemBuilder: (context, index) {
                                return _buildServiceCard(_services[index], index);
                              },
                            ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isBusy || _isLoading || !canPay) ? null : _onPayPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.successGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      canPay
                          ? 'Pay ₹${selected.price.toStringAsFixed(2)}'
                          : 'Pay',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

