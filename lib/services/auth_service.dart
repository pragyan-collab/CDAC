import 'dart:async';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  static const _otpTimeout = Duration(seconds: 5);
  static const _sendOtpTimeout = Duration(seconds: 5);

  /// Send OTP with timeout handling
  Future<bool> sendOTP(String aadhaarNumber) async {
    try {
      return await _sendOTPImpl(aadhaarNumber)
          .timeout(_sendOtpTimeout, onTimeout: () => false);
    } on TimeoutException {
      return false;
    }
  }

  Future<bool> _sendOTPImpl(String aadhaarNumber) async {
    await Future.delayed(const Duration(seconds: 2));
    return aadhaarNumber.length == 12 &&
        RegExp(r'^[0-9]+$').hasMatch(aadhaarNumber);
  }

  /// Verify OTP with timeout handling
  Future<UserModel?> verifyOTP(String otp) async {
    try {
      return await _verifyOTPImpl(otp)
          .timeout(_otpTimeout, onTimeout: () => null);
    } on TimeoutException {
      return null;
    }
  }

  Future<UserModel?> _verifyOTPImpl(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp.length == 6 && RegExp(r'^[0-9]+$').hasMatch(otp)) {
      _currentUser = UserModel(
        aadhaarNumber: '123456789012',
        name: 'Rahul Sharma',
        email: 'rahul@example.com',
        phone: '9876543210',
      );
      return _currentUser;
    }
    return null;
  }

  Future<bool> adminLogin(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock admin login
    return username == 'admin' && password == 'admin123';
  }

  void logout() {
    _currentUser = null;
  }
}