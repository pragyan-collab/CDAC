import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _currentIndex = 1;
  bool _isLoading = true;
  List<dynamic> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/service-catalog/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            _services = data is List ? data : [];
            _isLoading = false;
          });
        }
      } else {
        _handleError();
      }
    } catch (e) {
      _handleError();
    }
  }

  void _handleError() {
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load services')),
      );
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        SafeNavigation.navigateReplacementTo(AppRoutes.home);
        break;
      case 1:
        break;
      case 2:
        SafeNavigation.navigateReplacementTo(AppRoutes.schemesList);
        break;
      case 3:
        SafeNavigation.navigateReplacementTo(AppRoutes.newsList);
        break;
      case 4:
        SafeNavigation.navigateReplacementTo(AppRoutes.about);
        break;
    }
  }

  void _navigateToPayment(dynamic service) {
    double amount =
        double.tryParse(service['base_price']?.toString() ?? '0') ?? 0.0;

    SafeNavigation.navigateTo(
      AppRoutes.payment,
      arguments: {
        'serviceName': service['name'] ?? 'Service',
        'amount': amount,
        'applicationId':
        'APP_${DateTime.now().millisecondsSinceEpoch}',
      },
    );
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

  Widget _buildServiceCard(dynamic service) {
    final String name = service['name'] ?? 'Unknown Service';
    final String iconName = service['icon_name'] ?? '';
    final double price =
        double.tryParse(service['base_price']?.toString() ?? '0') ?? 0.0;

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
            "Fees: ₹$price",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: price > 0
              ? () => _navigateToPayment(service)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Pay Now',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_services.isEmpty) {
      return const Center(
        child: Text(
          'No services found.\nMake sure backend is running.',
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: AppConstants.pageBg,
            child: const Text(
              'Select a Service to Pay',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}