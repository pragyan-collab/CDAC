import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  
  String? _lastAadhaar;
  
  final String _baseUrl = 'http://10.0.2.2:8000/api/auth';

  Future<bool> sendOTP(String aadhaarNumber) async {
    try {
      // Use real backend validation to check if Aadhaar exists
      _lastAadhaar = aadhaarNumber;
      final response = await http.post(
        Uri.parse('$_baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'aadhaar_number': aadhaarNumber}),
      );
      if (response.statusCode == 200) {
        return true; // Aadhaar exists, proceed to OTP screen
      }
      return false; // Aadhaar not found
    } catch (e) {
      return false; // Network error or invalid
    }
  }

  Future<UserModel?> verifyOTP(String otp) async {
    try {
      // OTP is simulated as success, now fetch the real user data
      final response = await http.post(
        Uri.parse('$_baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'aadhaar_number': _lastAadhaar}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        await prefs.setString('access_token', data['access']);
        await prefs.setString('refresh_token', data['refresh']);
        
        _currentUser = UserModel(
          aadhaarNumber: _lastAadhaar ?? '',
          name: data['name'] ?? 'Demo User',
          email: '',
          phone: '',
        );
        return _currentUser;
      }
      return null;
    } catch (e) { 
      return null; 
    }
  }

  Future<bool> adminLogin(String username, String password) async { 
    return true; // Demo bypass
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}