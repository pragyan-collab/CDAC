// lib/main.dart
import 'package:flutter/material.dart';

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
import 'utils/constants.dart';
import 'utils/language_utils.dart';
import 'services/data_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
    });
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

      // Theme Configuration
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins',

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1E3A8A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1E3A8A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),

        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1E3A8A),
            side: const BorderSide(color: Color(0xFF1E3A8A)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1E3A8A),
          ),
        ),

        // Input Decoration Theme
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
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Color(0xFF6B7280)),
          hintStyle: TextStyle(color: Color(0xFF6B7280)),
        ),

        // Card Theme - Using the correct type
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Colors.white,
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1E3A8A),
          unselectedItemColor: Color(0xFF6B7280),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Tab Bar Theme - Using the correct type
        tabBarTheme: const TabBarThemeData(
          labelColor: Color(0xFF1E3A8A),
          unselectedLabelColor: Color(0xFF6B7280),
          indicatorColor: Color(0xFF1E3A8A),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF97316),
          foregroundColor: Colors.white,
        ),

        // Dialog Theme - Using the correct type
        dialogTheme: const DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),

        // Snackbar Theme
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),

      // Initial Route
      initialRoute: AppRoutes.splash,

      // All routes
      routes: {
        // Auth Routes
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.language: (context) => const LanguageScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.otp: (context) {
          // Get arguments if any
          final args = ModalRoute.of(context)?.settings.arguments;
          return const OTPScreen();
        },

        // User Routes
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.services: (context) => const ServicesScreen(),
        AppRoutes.apply: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const ApplyScreen();
        },
        AppRoutes.upload: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const UploadScreen();
        },
        AppRoutes.status: (context) => const StatusScreen(),

        // Payment Routes
        AppRoutes.payment: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const PaymentScreen();
        },
        AppRoutes.paymentWebview: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const PaymentWebview();
        },
        AppRoutes.receipt: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const ReceiptScreen();
        },

        // Admin Routes
        AppRoutes.adminLogin: (context) => const AdminLoginScreen(),
        AppRoutes.adminDashboard: (context) => const AdminDashboardScreen(),
        AppRoutes.adminDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const AdminDetailScreen();
        },

        // Info Routes
        AppRoutes.schemesList: (context) => const SchemesScreen(),
        AppRoutes.schemeDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return const SchemeDetailScreen();
        },
        AppRoutes.newsList: (context) => const NewsScreen(),
        AppRoutes.about: (context) => const AboutScreen(),
      },

      // Unknown Route
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
    );
  }
}