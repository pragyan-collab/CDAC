import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryBlue = Color(0xFF1e5fbf);
  static const Color primaryBlueDark = Color(0xFF0a3d7a);
  static const Color primaryOrange = Color(0xFFff9933);
  static const Color primaryOrangeDark = Color(0xFFcc6600);
  static const Color successGreen = Color(0xFF28a745);
  static const Color successGreenDark = Color(0xFF1e7e34);
  static const Color errorRed = Color(0xFFdc3545);
  static const Color errorBg = Color(0xFFffe6e6);
  static const Color pageBg = Color(0xFFf0f7ff);
  static const Color white = Color(0xFFffffff);
  static const Color filledBox = Color(0xFFe3f2fd);
  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF666666);

  // Shadows
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryBlueDark.withOpacity(0.3),
      offset: const Offset(0, 4),
      blurRadius: 6,
    )
  ];

  static List<BoxShadow> get orangeButtonShadow => [
    BoxShadow(
      color: primaryOrangeDark.withOpacity(0.3),
      offset: const Offset(0, 4),
      blurRadius: 6,
    )
  ];

  // Padding
  static const double screenPadding = 16.0;
  static const double cardPadding = 12.0;

  // Border Radius
  static const double buttonRadius = 8.0;
  static const double cardRadius = 12.0;

  // Font Sizes
  static const double headingSize = 24.0;
  static const double subHeadingSize = 18.0;
  static const double bodySize = 14.0;
}

class AppStrings {
  static const String appName = 'JanSeva';
  static const String tagline = 'सुविधा आपके द्वार';

  // Auth
  static const String enterAadhaar = 'Enter Aadhaar Number';
  static const String enterOTP = 'Enter OTP';
  static const String login = 'Login';
  static const String verify = 'Verify';
  static const String resendOTP = 'Resend OTP';

  // Common
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String loading = 'Loading...';

  // Bottom Nav
  static const String home = 'Home';
  static const String services = 'Services';
  static const String schemes = 'Schemes';
  static const String news = 'News';
  static const String more = 'More';
}