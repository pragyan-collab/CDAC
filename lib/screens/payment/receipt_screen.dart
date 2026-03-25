// lib/screens/payment/receipt_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/kiosk_busy_overlay.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String receiptId = '';
  double amount = 0.0;
  String serviceName = '';
  String applicationId = '';

  bool _argsLoaded = false;
  bool _isBusy = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      _argsLoaded = true;
      _getArguments();
    }
  }

  void _getArguments() {
    final args = ArgumentHelper.getArgument<Map>(
      context,
      routeName: AppRoutes.receipt,
    );
    if (args != null) {
      receiptId = (args['receiptId'] as String?) ?? '';
      amount = (args['amount'] ?? 0.0).toDouble();
      serviceName = (args['serviceName'] as String?) ?? '';
      applicationId = (args['applicationId'] as String?) ?? '';
    }
  }

  Future<void> _navigateToHome() async {
    await SafeNavigation.navigateAndRemoveUntil(AppRoutes.home);
  }

  Future<void> _navigateToStatus() async {
    await SafeNavigation.navigateTo(AppRoutes.status);
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.receipt);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentDate = DateTime.now();

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: KioskBusyOverlay(
        isBusy: _isBusy,
        message: 'Please wait...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).padding.bottom + 32,
            ),
            child: Column(
          children: [
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

            const SizedBox(height: 20),

            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your application has been submitted',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textMedium,
              ),
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/emblem.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Government of India',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textDark,
                              ),
                            ),
                            Text(
                              'Payment Receipt',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppConstants.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  _buildReceiptRow('Receipt No.', receiptId),
                  _buildReceiptRow(
                    'Date',
                    '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}',
                  ),
                  _buildReceiptRow(
                    'Time',
                    '${paymentDate.hour.toString().padLeft(2, '0')}:${paymentDate.minute.toString().padLeft(2, '0')}',
                  ),

                  const Divider(height: 24),

                  _buildReceiptRow('Application ID', applicationId),
                  _buildReceiptRow('Service', serviceName),

                  const Divider(height: 24),

                  _buildReceiptRow(
                    'Amount Paid',
                    '₹${amount.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                  _buildReceiptRow('Payment Mode', 'UPI'),
                  _buildReceiptRow(
                    'Transaction ID',
                    'TXN${DateTime.now().millisecondsSinceEpoch}',
                  ),

                  const SizedBox(height: 20),

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
                            width: MediaQuery.of(context).size.width * 0.45,
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

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isBusy
                        ? null
                        : () => _runBusyAction(() async {
                              await Future.delayed(
                                const Duration(milliseconds: 400),
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Receipt downloaded'),
                                  backgroundColor: AppConstants.successGreen,
                                ),
                              );
                            }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.primaryBlue,
                      side: const BorderSide(color: AppConstants.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isBusy ? null : () => _runBusyAction(_navigateToHome),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Go to Home'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: _isBusy ? null : () => _runBusyAction(_navigateToStatus),
              child: const Text(
                'Track Application Status',
                style: TextStyle(
                  color: AppConstants.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
            label,
            style: TextStyle(
              color: AppConstants.textMedium,
              fontSize: 14,
            ),
          ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppConstants.textDark,
                fontSize: 14,
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}