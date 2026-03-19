// lib/screens/info/scheme_detail_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../models/scheme_model.dart';
import '../../widgets/safe_navigation.dart';

class SchemeDetailScreen extends StatefulWidget {
  const SchemeDetailScreen({Key? key}) : super(key: key);

  @override
  State<SchemeDetailScreen> createState() => _SchemeDetailScreenState();
}

class _SchemeDetailScreenState extends State<SchemeDetailScreen> {
  SchemeModel? scheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (scheme == null) {
      final args = ArgumentHelper.getArgument<Map>(
        context,
        routeName: AppRoutes.schemeDetail,
      );

      if (args != null && args['scheme'] != null) {
        scheme = args['scheme'] as SchemeModel;
      }
    }
  }

  void _navigateToApply() {
    if (scheme == null) return;

    SafeNavigation.navigateTo(
      AppRoutes.apply,
      arguments: {'service': scheme!.title},
    );
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.schemeDetail);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (scheme == null) {
      return Scaffold(
        appBar: const HeaderWidget(showBackButton: true),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppConstants.primaryBlue,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppConstants.primaryBlue,
                    AppConstants.primaryBlueDark
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Government Scheme',
                    style: TextStyle(
                      color: AppConstants.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scheme!.title,
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scheme!.department,
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.primaryOrange),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppConstants.primaryOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last Date to Apply',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.textDark,
                          ),
                        ),
                        Text(
                          '${scheme!.lastDate.day}/${scheme!.lastDate.month}/${scheme!.lastDate.year}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSection('About the Scheme', scheme!.description),
            const SizedBox(height: 16),
            _buildSection('Eligibility Criteria', scheme!.eligibility, icon: Icons.check_circle),
            const SizedBox(height: 16),
            _buildSection('Benefits', scheme!.benefits, icon: Icons.emoji_events),
            const SizedBox(height: 16),
            _buildSection('Documents Required', scheme!.documents, icon: Icons.description),
            const SizedBox(height: 16),
            _buildSection('How to Apply', scheme!.applicationProcess, icon: Icons.assignment),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.successGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share feature coming soon'),
                  ),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Scheme'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.primaryBlue,
                side: const BorderSide(color: AppConstants.primaryBlue),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.buttonShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppConstants.primaryBlue, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: AppConstants.textMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}