// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/input_validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<TextEditingController> _boxControllers =
  List.generate(12, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(12, (_) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (var controller in _boxControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onAadhaarChanged(String value, int index) {
    if (value.isNotEmpty && index < 11) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  String _getFullAadhaar() {
    return _boxControllers.map((c) => c.text).join();
  }

  Future<void> _sendOTP() async {
    if (_isLoading) return;

    final aadhaar = _getFullAadhaar();

    if (!InputValidators.isValidAadhaar(aadhaar)) {
      setState(() =>
          _errorMessage = 'Please enter valid 12-digit Aadhaar number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await AuthService().sendOTP(aadhaar);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      // ✅ UPDATED (NO CONTEXT)
      SafeNavigation.navigateTo(
        AppRoutes.otp,
        arguments: {'aadhaar': aadhaar},
      );
    } else {
      setState(() => _errorMessage = 'Invalid Aadhaar number');
    }
  }

  void _navigateToAdmin() {
    // ✅ UPDATED (NO CONTEXT)
    SafeNavigation.navigateTo(AppRoutes.adminLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: _isLoading
          ? const LoadingWidget(message: 'Sending OTP...')
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your Aadhaar number to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.textMedium,
                ),
              ),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: List.generate(12, (index) {
                        return SizedBox(
                          width: 28,
                          height: 48,
                          child: TextField(
                            controller: _boxControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: _boxControllers[index]
                                  .text
                                  .isNotEmpty
                                  ? AppConstants.primaryBlue
                                  .withOpacity(0.1)
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: index == 3 || index == 7
                                      ? AppConstants.primaryOrange
                                      : AppConstants.primaryBlue,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: index == 3 || index == 7
                                      ? AppConstants.primaryOrange
                                      : AppConstants.primaryBlue
                                      .withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: index == 3 || index == 7
                                      ? AppConstants.primaryOrange
                                      : AppConstants.primaryBlue,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) =>
                                _onAadhaarChanged(value, index),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryBlue
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.security,
                              color:
                              AppConstants.primaryBlue,
                              size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your Aadhaar information is secure and encrypted',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                AppConstants.textMedium,
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
                      const Icon(Icons.error,
                          color: AppConstants.errorRed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color:
                              AppConstants.errorRed),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppConstants.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: _navigateToAdmin,
                  child: const Text(
                    'Admin Login',
                    style: TextStyle(
                      color: AppConstants.primaryBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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