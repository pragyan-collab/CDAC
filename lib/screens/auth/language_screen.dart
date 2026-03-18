// lib/screens/auth/language_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/language_utils.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Emblem
              Container(
                height: 120,
                child: Image.asset(
                  'assets/images/emblem.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // App Name
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                AppStrings.tagline,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textMedium,
                ),
              ),

              const SizedBox(height: 60),

              // Language Selection Title
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 30),

              // English Button
              _buildLanguageButton(
                context,
                language: 'English',
                flag: '🇬🇧',
                onTap: () {
                  LanguageUtils().setLanguage('en');
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 16),

              // Hindi Button
              _buildLanguageButton(
                context,
                language: 'हिन्दी',
                flag: '🇮🇳',
                onTap: () {
                  LanguageUtils().setLanguage('hi');
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 16),

              // Marathi Button
              _buildLanguageButton(
                context,
                language: 'मराठी',
                flag: '🇮🇳',
                onTap: () {
                  LanguageUtils().setLanguage('mr');
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),

              const SizedBox(height: 40),

              // Note
              const Text(
                'You can change language later in settings',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
      BuildContext context, {
        required String language,
        required String flag,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppConstants.primaryBlue.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: AppConstants.white,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Text(
              language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppConstants.textDark,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.primaryBlue,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}