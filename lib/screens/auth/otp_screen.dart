// lib/screens/auth/otp_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../utils/input_validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/otp_input_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<OtpInputWidgetState> _otpInputKey = GlobalKey();
  String _otpValue = '';

  bool _isLoading = false;
  String? _errorMessage;

  int _timerSeconds = 30;
  bool _canResend = false;

  String _aadhaar = '';
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      final args = ArgumentHelper.getArgument<Map>(
        context,
        routeName: AppRoutes.otp,
      );

      if (args != null) {
        _aadhaar = (args['aadhaar'] as String?) ?? '';
      }

      _startTimer();
      _isInit = true;
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
        _startTimer();
      } else {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_isLoading) return;

    if (!InputValidators.isValidOtp(_otpValue)) {
      setState(() => _errorMessage = 'Please enter valid 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await AuthService().verifyOTP(_otpValue);

      if (!mounted) return;

      if (user != null) {
        ArgumentHelper.clearArguments(AppRoutes.otp);

        // Unfocus before navigation to avoid focus-related disposal issues
        _otpInputKey.currentState?.unfocusAll();

        // Defer navigation to next frame - allows clean widget teardown
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          SafeNavigation.navigateReplacementTo(AppRoutes.home);
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid OTP';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  void _resendOTP() {
    if (_canResend && !_isLoading) {
      setState(() {
        _canResend = false;
        _timerSeconds = 30;
      });

      _startTimer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully'),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    }
  }

  void _handleBackPressed() {
    // Unfocus OTP fields before pop - ensures clean disposal
    _otpInputKey.currentState?.unfocusAll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SafeNavigation.pop();
    });
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.otp);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        showBackButton: true,
        onBackPressed: _handleBackPressed,
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Verifying OTP...')
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'OTP sent to Aadhaar XXXX XXXX ${_aadhaar.length >= 8 ? _aadhaar.substring(8) : ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppConstants.textMedium,
                      ),
                    ),
                    const SizedBox(height: 40),
                    OtpInputWidget(
                      key: _otpInputKey,
                      length: 6,
                      onChanged: (value) => setState(() => _otpValue = value),
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.errorBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error,
                              color: AppConstants.errorRed,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppConstants.errorRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _canResend
                              ? "Didn't receive OTP? "
                              : 'Resend OTP in $_timerSeconds seconds',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppConstants.textMedium,
                          ),
                        ),
                        if (_canResend)
                          TextButton(
                            onPressed: _resendOTP,
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                color: AppConstants.primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.successGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
