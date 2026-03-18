import 'dart:async';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Mock login
  Future<bool> sendOTP(String aadhaarNumber) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock validation - accept any 12 digit number
    return aadhaarNumber.length == 12 && RegExp(r'^[0-9]+$').hasMatch(aadhaarNumber);
  }

  Future<UserModel?> verifyOTP(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock verification - accept any 6 digit OTP
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