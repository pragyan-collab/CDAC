import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/input_validators.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  String? _lastAadhaar;

  // Kiosk mock auth configuration
  static const String _authorizedAadhaar = '123456789012';
  static const String _authorizedName = 'Abhishek Nanda';

  // Keep existing token key names so existing logout code still works.
  static const String _prefsAccessTokenKey = 'access_token';
  static const String _prefsRefreshTokenKey = 'refresh_token';
  static const String _prefsAuthorizedAadhaarKey = 'authorized_aadhaar';

  Future<bool> sendOTP(String aadhaarNumber) async {
    _lastAadhaar = aadhaarNumber.replaceAll(' ', '');
    // In kiosk mode: Aadhaar-only auth. OTP is validated later.
    return _lastAadhaar == _authorizedAadhaar;
  }

  Future<UserModel?> verifyOTP(String otp) async {
    final normalizedOtp = otp.replaceAll(' ', '');
    final aadhaar = _lastAadhaar?.replaceAll(' ', '');

    // OTP rule per requirement: accept any valid 6-digit OTP
    // but only if Aadhaar is the authorized kiosk Aadhaar.
    if (aadhaar != _authorizedAadhaar || !InputValidators.isValidOtp(normalizedOtp)) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsAccessTokenKey, 'mock_access_token');
    await prefs.setString(_prefsRefreshTokenKey, 'mock_refresh_token');
    await prefs.setString(_prefsAuthorizedAadhaarKey, _authorizedAadhaar);

    _currentUser = UserModel(
      aadhaarNumber: _authorizedAadhaar,
      name: _authorizedName,
      email: '',
      phone: '',
    );
    return _currentUser;
  }

  Future<bool> adminLogin(String username, String password) async { 
    // Kiosk behavior: only allow admin screens when kiosk auth succeeded.
    // Username/password are not validated in this local mock.
    return _currentUser != null;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsAccessTokenKey);
    await prefs.remove(_prefsRefreshTokenKey);
    await prefs.remove(_prefsAuthorizedAadhaarKey);
    _lastAadhaar = null;
  }

  /// Restore kiosk session from SharedPreferences on app startup.
  /// Ensures route protection can work synchronously after initialization.
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_prefsAccessTokenKey);
    final storedAadhaar = prefs.getString(_prefsAuthorizedAadhaarKey);

    final isValidSession = accessToken != null &&
        accessToken.isNotEmpty &&
        storedAadhaar == _authorizedAadhaar;

    if (isValidSession) {
      _currentUser = UserModel(
        aadhaarNumber: _authorizedAadhaar,
        name: _authorizedName,
        email: '',
        phone: '',
      );
    } else {
      _currentUser = null;
    }
  }
}