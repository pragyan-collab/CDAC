import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/loading_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _timerSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
            _startTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  Future<void> _verifyOTP() async {
    String otp = _otpController.text;

    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = await AuthService().verifyOTP(otp);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _errorMessage = 'Invalid OTP';
      });
    }
  }

  void _resendOTP() {
    if (_canResend) {
      setState(() {
        _canResend = false;
        _timerSeconds = 30;
      });
      _startTimer();
      // Implement resend OTP logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final aadhaar = args?['aadhaar'] ?? '';

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: _isLoading
          ? const LoadingWidget(message: 'Verifying OTP...')
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'OTP sent to Aadhaar **** **** $aadhaar',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textMedium,
                ),
              ),
              const SizedBox(height: 32),

              // OTP input
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 60,
                  fieldWidth: 45,
                  activeFillColor: AppConstants.white,
                  activeColor: AppConstants.primaryBlue,
                  selectedFillColor: AppConstants.white,
                  selectedColor: AppConstants.primaryOrange,
                  inactiveFillColor: AppConstants.white,
                  inactiveColor: AppConstants.primaryBlue.withOpacity(0.3),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    _verifyOTP();
                  }
                },
              ),

              const SizedBox(height: 16),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.errorBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: AppConstants.errorRed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppConstants.errorRed),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Timer and resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResend ? 'Didn\'t receive OTP? ' : 'Resend OTP in $_timerSeconds seconds',
                    style: const TextStyle(color: AppConstants.textMedium),
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

              const SizedBox(height: 32),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.successGreen,
                    foregroundColor: AppConstants.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}