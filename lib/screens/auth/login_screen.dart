import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final List<TextEditingController> _boxControllers = List.generate(12, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(12, (_) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _aadhaarController.dispose();
    for (var controller in _boxControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onAadhaarChanged(String value, int index) {
    if (value.length == 1 && index < 11) {
      _focusNodes[index + 1].requestFocus();
    }

    // Update the main controller
    String fullAadhaar = '';
    for (var controller in _boxControllers) {
      fullAadhaar += controller.text;
    }
    _aadhaarController.text = fullAadhaar;
  }

  Future<void> _sendOTP() async {
    String aadhaar = _aadhaarController.text;

    if (aadhaar.length != 12) {
      setState(() {
        _errorMessage = 'Please enter 12-digit Aadhaar number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = await AuthService().sendOTP(aadhaar);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.otp,
        arguments: {'aadhaar': aadhaar},
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid Aadhaar number';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(title: 'Login', showBackButton: false),
      body: _isLoading
          ? const LoadingWidget(message: 'Sending OTP...')
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your Aadhaar number to continue',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textMedium,
                ),
              ),
              const SizedBox(height: 32),

              // Aadhaar boxes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(12, (index) {
                        return SizedBox(
                          width: 22,
                          child: TextField(
                            controller: _boxControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: _boxControllers[index].text.isNotEmpty
                                  ? AppConstants.filledBox
                                  : AppConstants.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(color: AppConstants.primaryBlue),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: index == 3 || index == 7
                                      ? AppConstants.primaryOrange
                                      : AppConstants.primaryBlue,
                                ),
                              ),
                            ),
                            onChanged: (value) => _onAadhaarChanged(value, index),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Security note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.security, color: AppConstants.primaryBlue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your Aadhaar information is secure and encrypted',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConstants.textMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
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
              ],

              const SizedBox(height: 32),

              // Voice button
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryOrange,
                    shape: BoxShape.circle,
                    boxShadow: AppConstants.orangeButtonShadow,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: AppConstants.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Speak Aadhaar Number',
                  style: TextStyle(
                    color: AppConstants.textMedium,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Send OTP button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryBlue,
                    foregroundColor: AppConstants.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Admin login link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.adminLogin);
                  },
                  child: const Text(
                    'Admin Login',
                    style: TextStyle(
                      color: AppConstants.primaryBlue,
                      fontWeight: FontWeight.w500,
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