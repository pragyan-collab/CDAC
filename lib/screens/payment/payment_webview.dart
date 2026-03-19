// lib/screens/payment/payment_webview.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../services/payment_service.dart';
import '../../widgets/safe_navigation.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({Key? key}) : super(key: key);

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  WebViewController? _controller;

  bool _isLoading = true;
  bool _paymentComplete = false;

  double amount = 0.0;
  String applicationId = '';
  String paymentLink = '';

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
        routeName: AppRoutes.paymentWebview,
      );

      if (args != null) {
        paymentLink = (args['paymentLink'] as String?) ?? '';
        amount = (args['amount'] ?? 0.0).toDouble();
        applicationId = (args['applicationId'] as String?) ?? '';
      }

      if (paymentLink.isNotEmpty) {
        _initializeWebView();
      } else {
        _showError('Invalid payment link');
      }
    } catch (e) {
      _showError('Argument error: $e');
    }
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url.toLowerCase();

            // ✅ Detect success/failure URLs
            if (url.contains('success') ||
                url.contains('payment_success') ||
                url.contains('status=success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }

            if (url.contains('failure') ||
                url.contains('cancel') ||
                url.contains('payment_failed')) {
              _handlePaymentFailure();
              return NavigationDecision.prevent;
            }

            // Deep link support
            if (url.startsWith('civickiosk://')) {
              if (url.contains('success')) {
                _handlePaymentSuccess();
              } else {
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
      _isLoading = true;
    });

    try {
      final verified =
      await PaymentService().verifyPayment('upi_payment_id');

      if (!mounted) return;

      if (verified) {
        final receiptId = await PaymentService().generateReceipt(
          'upi_payment_id',
          amount,
          applicationId,
        );

        SafeNavigation.navigateReplacementTo(
          AppRoutes.receipt,
          arguments: {
            'receiptId': receiptId,
            'amount': amount,
            'serviceName': 'Service',
            'applicationId': applicationId,
          },
        );
      } else {
        _handlePaymentFailure();
      }
    } catch (e) {
      if (mounted) {
        _showError('Verification failed: $e');
      }
    }
  }

  void _handlePaymentFailure() {
    if (_paymentComplete) return;

    if (!mounted) return;
    setState(() => _paymentComplete = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text(
          'Your payment could not be processed.\nPlease try again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              SafeNavigation.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

  Future<bool> _onWillPop() async {
    if (_paymentComplete) return true;

    if (!mounted) return false;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Payment?'),
        content: const Text(
          'Are you sure you want to cancel the payment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.paymentWebview);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          SafeNavigation.pop();
        }
      },
      child: Scaffold(
        appBar: HeaderWidget(
          showBackButton: true,
          onBackPressed: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) {
              SafeNavigation.pop();
            }
          },
        ),
        body: Stack(
          children: [
            if (_controller != null)
              WebViewWidget(controller: _controller!)
            else
              const Center(child: Text('Loading payment...')),

            // 🔄 Loader overlay
            if (_isLoading)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryBlue),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
