// lib/screens/payment/payment_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../services/payment_service.dart';
import '../../widgets/safe_navigation.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'upi'; // ✅ default selected
  bool _isProcessing = false;

  double amount = 0.0;
  String serviceName = '';
  String applicationId = '';

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'upi',
      'name': 'UPI',
      'icon': Icons.qr_code_scanner,
      'color': Colors.blue,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.green,
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'color': Colors.purple,
    },
    {
      'id': 'wallet',
      'name': 'Mobile Wallet',
      'icon': Icons.account_balance_wallet,
      'color': Colors.orange,
    },
  ];

  bool _argsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      _argsLoaded = true;
      _getArguments();
    }
  }

  void _getArguments() {
    try {
      final args = ArgumentHelper.getArgument<Map>(
        context,
        routeName: AppRoutes.payment,
      );

      if (args != null) {
        amount = (args['amount'] ?? 0.0).toDouble();
        serviceName = args['serviceName'] ?? 'Service';
        applicationId = args['applicationId'] ?? '';
      }
    } catch (e) {
      debugPrint('Argument error: $e');
    }
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return; // ✅ prevent double click

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid payment amount'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      if (selectedMethod == 'upi') {
        final paymentLink =
        await PaymentService().initiatePayment(amount, applicationId);

        if (!mounted) return;

        setState(() => _isProcessing = false);

        SafeNavigation.navigateTo(
          AppRoutes.paymentWebview,
          arguments: {
            'paymentLink': paymentLink,
            'amount': amount,
            'applicationId': applicationId,
          },
        );
      } else {
        // Simulate processing
        await Future.delayed(const Duration(seconds: 2));

        final success =
        await PaymentService().verifyPayment('dummy_payment_id');

        if (!mounted) return;

        setState(() => _isProcessing = false);

        if (success) {
          final receiptId = await PaymentService().generateReceipt(
            'dummy_payment_id',
            amount,
            applicationId,
          );

          SafeNavigation.navigateReplacementTo(
            AppRoutes.receipt,
            arguments: {
              'receiptId': receiptId,
              'amount': amount,
              'serviceName': serviceName,
              'applicationId': applicationId,
            },
          );
        } else {
          _showError('Payment failed. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError('Error: $e');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.errorRed,
      ),
    );
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.payment);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: _isProcessing
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppConstants.primaryBlue),
            ),
            SizedBox(height: 16),
            Text(
              'Processing payment...',
              style: TextStyle(
                color: AppConstants.textMedium,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💳 Amount Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppConstants.primaryBlue,
                    AppConstants.primaryBlueDark
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      color: AppConstants.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'For: $serviceName',
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),

            const SizedBox(height: 20),

            // 💳 Payment Methods
            ...paymentMethods.map((method) {
              final isSelected = selectedMethod == method['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMethod = method['id'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.primaryBlue
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow:
                    isSelected ? AppConstants.buttonShadow : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: method['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          method['icon'],
                          color: method['color'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle,
                            color: AppConstants.primaryBlue),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // 🔐 Security Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                AppConstants.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock,
                      color: AppConstants.primaryBlue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment is secure and encrypted',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.successGreen,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Pay ₹${amount.toStringAsFixed(2)}',
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
    );
  }
}