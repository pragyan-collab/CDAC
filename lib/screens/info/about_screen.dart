// lib/screens/info/about_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/safe_navigation.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _currentIndex = 4;

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        SafeNavigation.navigateReplacementTo(AppRoutes.home);
        break;
      case 1:
        SafeNavigation.navigateReplacementTo(AppRoutes.services);
        break;
      case 2:
        SafeNavigation.navigateReplacementTo(AppRoutes.schemesList);
        break;
      case 3:
        SafeNavigation.navigateReplacementTo(AppRoutes.newsList);
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.white,
                shape: BoxShape.circle,
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Image.asset(
                'assets/images/emblem.png',
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.account_balance,
                    size: 80,
                    color: AppConstants.primaryBlue,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryBlue,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppStrings.tagline,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textMedium,
              ),
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: AppConstants.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildAboutCard(
              'About the App',
              'Civic Kiosk is a comprehensive digital platform designed to provide citizens with easy access to various government services.',
              Icons.info_outline,
            ),

            const SizedBox(height: 16),

            _buildAboutCard(
              'Key Features',
              '',
              Icons.star_outline,
              children: [
                _buildFeatureItem('Apply for services'),
                _buildFeatureItem('Upload documents'),
                _buildFeatureItem('Digital payments'),
                _buildFeatureItem('Track status'),
                _buildFeatureItem('Government schemes'),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              '© 2024 All Rights Reserved',
              style: TextStyle(
                fontSize: 10,
                color: AppConstants.textMedium,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildAboutCard(String title, String content, IconData icon,
      {List<Widget>? children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.buttonShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppConstants.primaryBlue),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(content),
            ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16),
          const SizedBox(width: 8),
          Text(feature),
        ],
      ),
    );
  }
}