// lib/screens/auth/splash_screen.dart
import 'package:flutter/material.dart';
import '../../utils/routes.dart';
import '../../utils/language_utils.dart';
import '../../widgets/loading_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLanguageAndNavigate();
  }

  Future<void> _checkLanguageAndNavigate() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    final hasSelectedLanguage = await LanguageUtils().hasSelectedLanguage();

    if (!mounted) return;

    if (hasSelectedLanguage) {
      // If language already selected, go to login
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      // If language not selected, go to language selection
      Navigator.pushReplacementNamed(context, AppRoutes.language);
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
            // Your splash screen content
            Image.asset(
              'assets/images/emblem.png',
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Civic Kiosk',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
          ],
        ),
      ),
    );
  }
}