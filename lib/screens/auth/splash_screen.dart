// lib/screens/auth/splash_screen.dart
import 'package:flutter/material.dart';
import '../../utils/routes.dart';
import '../../utils/language_utils.dart';
import '../../widgets/safe_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final hasSelectedLanguage =
      await LanguageUtils().hasSelectedLanguage();

      if (!mounted) return;

      if (hasSelectedLanguage) {
        // ✅ FIXED (removed context)
        SafeNavigation.navigateReplacementTo(AppRoutes.login);
      } else {
        // ✅ FIXED
        SafeNavigation.navigateReplacementTo(AppRoutes.language);
      }
    } catch (e) {
      if (!mounted) return;

      // ✅ FIXED
      SafeNavigation.navigateReplacementTo(AppRoutes.language);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/emblem.png',
              height: 120,
            ),
            const SizedBox(height: 24),
            const Text(
              'Civic Kiosk',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
          ],
        ),
      ),
    );
  }
}