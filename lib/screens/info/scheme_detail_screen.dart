import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/header_widget.dart';
import '../../models/scheme_model.dart';

class SchemeDetailScreen extends StatelessWidget {
  const SchemeDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final scheme = args['scheme'] as SchemeModel;

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConstants.primaryBlue, AppConstants.primaryBlueDark],
                ),
                borderRadius: BorderRadius.circular(12),
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
                    scheme.title,
                    style: const TextStyle(
                      color: AppConstants.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scheme.department,
                    style: TextStyle(
                      color: AppConstants.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Last Date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppConstants.primaryOrange),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppConstants.primaryOrange,
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
                          '${scheme.lastDate.day}/${scheme.lastDate.month}/${scheme.lastDate.year}',
                          style: const TextStyle(
                            fontSize: 18,
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

            // Description
            _buildSection(
              'About the Scheme',
              scheme.description,
            ),

            const SizedBox(height: 16),

            // Eligibility
            _buildSection(
              'Eligibility Criteria',
              scheme.eligibility,
              icon: Icons.check_circle,
            ),

            const SizedBox(height: 16),

            // Benefits
            _buildSection(
              'Benefits',
              scheme.benefits,
              icon: Icons.emoji_events,
            ),

            const SizedBox(height: 16),

            // Documents Required
            _buildSection(
              'Documents Required',
              scheme.documents,
              icon: Icons.description,
            ),

            const SizedBox(height: 16),

            // Application Process
            _buildSection(
              'How to Apply',
              scheme.applicationProcess,
              icon: Icons.assignment,
            ),

            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.apply,
                    arguments: {'service': scheme.title},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.successGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Share Button
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
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  fontSize: 16,
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
              fontSize: 14,
              color: AppConstants.textMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}