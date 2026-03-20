// lib/main.dart
import 'package:flutter/material.dart';

import 'widgets/safe_navigation.dart';

// Auth Screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/language_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/otp_screen.dart';

// User Screens
import 'screens/user/home_screen.dart';
import 'screens/user/services_screen.dart';
import 'screens/user/apply_screen.dart';
import 'screens/user/upload_screen.dart';
import 'screens/user/status_screen.dart';
import 'screens/user/chatbot_screen.dart';

// Payment Screens
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_webview.dart';
import 'screens/payment/receipt_screen.dart';

// Admin Screens
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_detail_screen.dart';

// Info Screens
import 'screens/info/schemes_screen.dart';
import 'screens/info/scheme_detail_screen.dart';
import 'screens/info/news_screen.dart';
import 'screens/info/about_screen.dart';

// Utils and Services
import 'utils/routes.dart';
import 'utils/language_utils.dart';
import 'utils/error_handler.dart';
import 'services/data_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize error handler FIRST
  ErrorHandler.initialize();

  DataService().initMockData();
  runApp(const CivicKioskApp());
}

class CivicKioskApp extends StatefulWidget {
  const CivicKioskApp({Key? key}) : super(key: key);

  @override
  State<CivicKioskApp> createState() => _CivicKioskAppState();
}

class _CivicKioskAppState extends State<CivicKioskApp> {
  final LanguageUtils _languageUtils = LanguageUtils();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _languageUtils.getLanguage();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Civic Kiosk',
      debugShowCheckedModeBanner: false,
      navigatorKey: SafeNavigation.navigatorKey,
      theme: _buildTheme(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // Auth Routes
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.otp:
        return MaterialPageRoute(
          builder: (_) => const OTPScreen(),
          settings: settings,
        );

    // User Routes
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.services:
        return MaterialPageRoute(builder: (_) => const ServicesScreen());
      case AppRoutes.apply:
        return MaterialPageRoute(
          builder: (_) => const ApplyScreen(),
          settings: settings,
        );
      case AppRoutes.upload:
        return MaterialPageRoute(
          builder: (_) => const UploadScreen(),
          settings: settings,
        );
      case AppRoutes.status:
        return MaterialPageRoute(builder: (_) => const StatusScreen());
      case AppRoutes.chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());

    // Payment Routes
      case AppRoutes.payment:
        return MaterialPageRoute(
          builder: (_) => const PaymentScreen(),
          settings: settings,
        );
      case AppRoutes.paymentWebview:
        return MaterialPageRoute(
          builder: (_) => const PaymentWebview(),
          settings: settings,
        );
      case AppRoutes.receipt:
        return MaterialPageRoute(
          builder: (_) => const ReceiptScreen(),
          settings: settings,
        );

    // Admin Routes
      case AppRoutes.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case AppRoutes.adminDetail:
        return MaterialPageRoute(
          builder: (_) => const AdminDetailScreen(),
          settings: settings,
        );

    // Info Routes
      case AppRoutes.schemesList:
        return MaterialPageRoute(builder: (_) => const SchemesScreen());
      case AppRoutes.schemeDetail:
        return MaterialPageRoute(
          builder: (_) => const SchemeDetailScreen(),
          settings: settings,
        );
      case AppRoutes.newsList:
        return MaterialPageRoute(builder: (_) => const NewsScreen());
      case AppRoutes.about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF1E3A8A),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E3A8A)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFF1E3A8A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Color(0xFFDC2626)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF1E3A8A),
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}