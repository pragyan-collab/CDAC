import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/header_widget.dart';
import '../../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
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

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    amount = args['amount'] ?? 0.0;
    serviceName = args['serviceName'] ?? 'Service';
    applicationId = args['applicationId'] ?? '';
  }

  Future<void> _processPayment() async {
    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // For UPI, navigate to webview
    if (selectedMethod == 'upi') {
      final paymentLink = await PaymentService().initiatePayment(amount, applicationId);

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      Navigator.pushNamed(
        context,
        AppRoutes.paymentWebview,
        arguments: {
          'paymentLink': paymentLink,
          'amount': amount,
          'applicationId': applicationId,
        },
      );
    } else {
      // Simulate payment for other methods
      await Future.delayed(const Duration(seconds: 2));

      final success = await PaymentService().verifyPayment('dummy_payment_id');

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      if (success) {
        final receiptId = await PaymentService().generateReceipt(
          'dummy_payment_id',
          amount,
          applicationId,
        );

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.receipt,
          arguments: {
            'receiptId': receiptId,
            'amount': amount,
            'serviceName': serviceName,
            'applicationId': applicationId,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: AppConstants.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: _isProcessing
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
            ),
            const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConstants.primaryBlue, AppConstants.primaryBlueDark],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      color: AppConstants.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'For: $serviceName',
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Methods
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: 16),

            ...paymentMethods.map((method) {
              final isSelected = selectedMethod == method['id'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMethod = method['id'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.primaryBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: AppConstants.buttonShadow,
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
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppConstants.primaryBlue,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Security Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock, color: AppConstants.primaryBlue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment is secure and encrypted',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.textMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.successGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Pay ₹${amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}