import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _currentIndex = 4;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(title: 'About', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Logo
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

            // Version
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

            // About Card
            _buildAboutCard(
              'About the App',
              'Civic Kiosk is a comprehensive digital platform designed to provide citizens with easy access to various government services. From applying for certificates to tracking application status, making payments, and staying updated with the latest schemes and news - all at your fingertips.',
              Icons.info_outline,
            ),

            const SizedBox(height: 16),

            // Features
            _buildAboutCard(
              'Key Features',
              '',
              Icons.star_outline,
              children: [
                _buildFeatureItem('Apply for government services online'),
                _buildFeatureItem('Upload documents securely'),
                _buildFeatureItem('Make digital payments'),
                _buildFeatureItem('Track application status'),
                _buildFeatureItem('View government schemes'),
                _buildFeatureItem('Get latest news and updates'),
                _buildFeatureItem('Multi-language support'),
                _buildFeatureItem('Voice-enabled interface'),
              ],
            ),

            const SizedBox(height: 16),

            // Contact & Support
            _buildAboutCard(
              'Contact & Support',
              '',
              Icons.contact_support_outlined,
              children: [
                ListTile(
                  leading: const Icon(Icons.phone, color: AppConstants.primaryBlue),
                  title: const Text('Toll Free Helpline'),
                  subtitle: const Text('1800-123-4567'),
                  onTap: () => _launchURL('tel:18001234567'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email, color: AppConstants.primaryBlue),
                  title: const Text('Email Support'),
                  subtitle: const Text('support@civickiosk.gov.in'),
                  onTap: () => _launchURL('mailto:support@civickiosk.gov.in'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.language, color: AppConstants.primaryBlue),
                  title: const Text('Official Website'),
                  subtitle: const Text('www.civickiosk.gov.in'),
                  onTap: () => _launchURL('https://www.civickiosk.gov.in'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Office Address
            _buildAboutCard(
              'Office Address',
              '',
              Icons.location_on_outlined,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Centre for Development of Advanced Computing (C-DAC)\n'
                        'Pune University Campus,\n'
                        'Ganeshkhind, Pune - 411007\n'
                        'Maharashtra, India',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textMedium,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Social Media Links
            _buildAboutCard(
              'Follow Us',
              '',
              Icons.share_outlined,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      Icons.facebook,
                      'Facebook',
                      'https://facebook.com/cdac',
                    ),
                    _buildSocialButton(
                      Icons.tag,
                      'Twitter',
                      'https://twitter.com/cdac',
                    ),
                    _buildSocialButton(
                      Icons.video_library,
                      'YouTube',
                      'https://youtube.com/cdac',
                    ),
                    _buildSocialButton(
                      Icons.link,
                      'LinkedIn',
                      'https://linkedin.com/company/cdac',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Developed by
            const Text(
              'Developed by C-DAC for Digital India Initiative',
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.textMedium,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch(index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.services);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.schemesList);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.newsList);
              break;
            case 4:
            // Already here
              break;
          }
        },
      ),
    );
  }

  Widget _buildAboutCard(String title, String content, IconData icon, {List<Widget>? children}) {
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppConstants.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textMedium,
                  height: 1.5,
                ),
              ),
            ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppConstants.successGreen,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppConstants.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppConstants.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}