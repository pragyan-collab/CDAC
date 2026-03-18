import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/header_widget.dart';
import '../../services/payment_service.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({Key? key}) : super(key: key);

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentComplete = false;

  double amount = 0.0;
  String applicationId = '';

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final paymentLink = args['paymentLink'] ?? '';
    amount = args['amount'] ?? 0.0;
    applicationId = args['applicationId'] ?? '';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });

            // Check if payment success URL is loaded
            if (url.contains('success') || url.contains('receipt')) {
              _handlePaymentSuccess();
            } else if (url.contains('failure') || url.contains('cancel')) {
              _handlePaymentFailure();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle deep links or callbacks
            if (request.url.startsWith('civickiosk://')) {
              if (request.url.contains('payment_success')) {
                _handlePaymentSuccess();
              } else if (request.url.contains('payment_failed')) {
                _handlePaymentFailure();
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentLink));
  }

  Future<void> _handlePaymentSuccess() async {
    if (_paymentComplete) return;

    setState(() {
      _paymentComplete = true;
    });

    final verified = await PaymentService().verifyPayment('upi_payment_id');

    if (!mounted) return;

    if (verified) {
      final receiptId = await PaymentService().generateReceipt(
        'upi_payment_id',
        amount,
        applicationId,
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.receipt,
        arguments: {
          'receiptId': receiptId,
          'amount': amount,
          'serviceName': 'Service',
          'applicationId': applicationId,
        },
      );
    }
  }

  void _handlePaymentFailure() {
    if (_paymentComplete) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Failed'),
          content: const Text('Your payment could not be processed. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to payment screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: AppConstants.white,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}