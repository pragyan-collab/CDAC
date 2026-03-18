import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/services_screen.dart';
import 'screens/user/apply_screen.dart';
import 'screens/user/upload_screen.dart';
import 'screens/user/status_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_webview.dart';
import 'screens/payment/receipt_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_detail_screen.dart';
import 'screens/info/schemes_screen.dart';
import 'screens/info/scheme_detail_screen.dart';
import 'screens/info/news_screen.dart';
import 'screens/info/about_screen.dart';
import 'utils/routes.dart';
import 'utils/constants.dart';
import 'services/data_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DataService().initMockData();
  runApp(const CivicKioskApp());
}

class CivicKioskApp extends StatelessWidget {
  const CivicKioskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.primaryBlue,
        scaffoldBackgroundColor: AppConstants.pageBg,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppConstants.primaryBlue),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryBlue,
            foregroundColor: AppConstants.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppConstants.primaryBlue,
            side: const BorderSide(color: AppConstants.primaryBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppConstants.primaryBlue,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppConstants.primaryBlue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppConstants.primaryBlue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppConstants.errorRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppConstants.errorRed, width: 2),
          ),
          filled: true,
          fillColor: AppConstants.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: AppConstants.textMedium),
          hintStyle: const TextStyle(color: AppConstants.textMedium),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppConstants.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppConstants.white,
          selectedItemColor: AppConstants.primaryBlue,
          unselectedItemColor: AppConstants.textMedium,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: AppConstants.primaryBlue,
          unselectedLabelColor: AppConstants.textMedium,
          indicatorColor: AppConstants.primaryBlue,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppConstants.primaryOrange,
          foregroundColor: AppConstants.white,
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.otp: (context) => const OTPScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.services: (context) => const ServicesScreen(),
        AppRoutes.apply: (context) => const ApplyScreen(),
        AppRoutes.upload: (context) => const UploadScreen(),
        AppRoutes.status: (context) => const StatusScreen(),
        AppRoutes.payment: (context) => const PaymentScreen(),
        AppRoutes.paymentWebview: (context) => const PaymentWebview(),
        AppRoutes.receipt: (context) => const ReceiptScreen(),
        AppRoutes.adminLogin: (context) => const AdminLoginScreen(),
        AppRoutes.adminDashboard: (context) => const AdminDashboardScreen(),
        AppRoutes.adminDetail: (context) => const AdminDetailScreen(),
        AppRoutes.schemesList: (context) => const SchemesScreen(),
        AppRoutes.schemeDetail: (context) => const SchemeDetailScreen(),
        AppRoutes.newsList: (context) => const NewsScreen(),
        AppRoutes.about: (context) => const AboutScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with arguments
        if (settings.name == AppRoutes.otp) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => OTPScreen(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.apply) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => ApplyScreen(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.upload) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => UploadScreen(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.payment) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => PaymentScreen(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.paymentWebview) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => PaymentWebview(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.receipt) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => ReceiptScreen(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.adminDetail) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => AdminDetailScreen(),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.schemeDetail) {
          final args = settings.arguments as Map?;
          return MaterialPageRoute(
            builder: (context) => SchemeDetailScreen(),
            settings: settings,
          );
        }
        return null;
      },
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