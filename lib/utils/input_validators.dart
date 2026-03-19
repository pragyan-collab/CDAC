// lib/utils/input_validators.dart
/// Input validation utilities to prevent injection and ensure data integrity.
class InputValidators {
  InputValidators._();

  static final _aadhaarRegex = RegExp(r'^[0-9]{12}$');
  static final _otpRegex = RegExp(r'^[0-9]{6}$');
  static final _mobileRegex = RegExp(r'^[6-9][0-9]{9}$');
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _nameRegex = RegExp(r"^[a-zA-Z\s\.'-]+$");

  /// Validates 12-digit Aadhaar number
  static bool isValidAadhaar(String value) {
    return _aadhaarRegex.hasMatch(value.replaceAll(' ', ''));
  }

  /// Validates 6-digit OTP
  static bool isValidOtp(String value) {
    return _otpRegex.hasMatch(value);
  }

  /// Validates Indian mobile number (10 digits, starting with 6-9)
  static bool isValidMobile(String value) {
    return _mobileRegex.hasMatch(value.replaceAll(RegExp(r'\s'), ''));
  }

  /// Validates email format
  static bool isValidEmail(String value) {
    if (value.isEmpty) return false;
    return _emailRegex.hasMatch(value.trim());
  }

  /// Validates name (letters, spaces, common punctuation)
  static bool isValidName(String value) {
    if (value.isEmpty || value.length < 2) return false;
    return _nameRegex.hasMatch(value.trim());
  }

  /// Sanitizes string to prevent injection (removes < > " ' & ;)
  static String sanitizeText(String value) {
    return value.replaceAll(RegExp(r'[<>"''&;]'), '').trim();
  }

  /// Validates PIN (4-6 digits)
  static bool isValidPin(String value) {
    return RegExp(r'^[0-9]{4,6}$').hasMatch(value);
  }
}
