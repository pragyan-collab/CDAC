// lib/screens/auth/language_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/language_utils.dart';
import '../../widgets/safe_navigation.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  void _selectLanguage(BuildContext context, String code) async {
    await LanguageUtils().setLanguage(code);

    if (context.mounted) {
      // ✅ FIXED (removed context)
      SafeNavigation.navigateReplacementTo(AppRoutes.login);
    }
  }

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
              SizedBox(
                height: 120,
                child: Image.asset(
                  'assets/images/emblem.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.tagline,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppConstants.textMedium,
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 30),

              _buildLanguageButton(
                language: 'English',
                flag: '🇬🇧',
                onTap: () => _selectLanguage(context, 'en'),
              ),
              const SizedBox(height: 16),

              _buildLanguageButton(
                language: 'हिन्दी',
                flag: '🇮🇳',
                onTap: () => _selectLanguage(context, 'hi'),
              ),
              const SizedBox(height: 16),

              _buildLanguageButton(
                language: 'मराठी',
                flag: '🇮🇳',
                onTap: () => _selectLanguage(context, 'mr'),
              ),

              const SizedBox(height: 40),
              const Text(
                'You can change language later in settings',
                style: TextStyle(
                  fontSize: 14,
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

  Widget _buildLanguageButton({
    required String language,
    required String flag,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppConstants.primaryBlue.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          color: AppConstants.white,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 28),
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
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}