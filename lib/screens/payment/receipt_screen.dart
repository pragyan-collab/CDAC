import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/header_widget.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final receiptId = args['receiptId'];
    final amount = args['amount'];
    final serviceName = args['serviceName'];
    final applicationId = args['applicationId'];
    final paymentDate = DateTime.now();

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Column(
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.successGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppConstants.successGreen,
                size: 80,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your application has been submitted',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textMedium,
              ),
            ),

            const SizedBox(height: 32),

            // Receipt Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/emblem.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Government of India',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textDark,
                              ),
                            ),
                            Text(
                              'Payment Receipt',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConstants.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Receipt Details
                  _buildReceiptRow('Receipt No.', receiptId),
                  _buildReceiptRow('Date', '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}'),
                  _buildReceiptRow('Time', '${paymentDate.hour}:${paymentDate.minute}:${paymentDate.second}'),

                  const Divider(height: 24),

                  _buildReceiptRow('Application ID', applicationId),
                  _buildReceiptRow('Service', serviceName),

                  const Divider(height: 24),

                  _buildReceiptRow('Amount Paid', '₹${amount.toStringAsFixed(2)}', isBold: true),
                  _buildReceiptRow('Payment Mode', 'UPI'),
                  _buildReceiptRow('Transaction ID', 'TXN${DateTime.now().millisecondsSinceEpoch}'),

                  const SizedBox(height: 20),

                  // Stamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Authorized Signature',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 150,
                            height: 2,
                            color: AppConstants.textDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Share receipt
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Receipt downloaded'),
                          backgroundColor: AppConstants.successGreen,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.primaryBlue,
                      side: const BorderSide(color: AppConstants.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Go to Home'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.status);
              },
              child: const Text(
                'Track Application Status',
                style: TextStyle(
                  color: AppConstants.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppConstants.textMedium,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppConstants.textDark,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}