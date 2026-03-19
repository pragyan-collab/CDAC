// lib/screens/admin/admin_detail_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../models/application_model.dart';

class AdminDetailScreen extends StatefulWidget {
  const AdminDetailScreen({Key? key}) : super(key: key);

  @override
  State<AdminDetailScreen> createState() =>
      _AdminDetailScreenState();
}

class _AdminDetailScreenState
    extends State<AdminDetailScreen> {
  ApplicationModel? application; // ✅ FIXED (nullable)
  bool _isProcessing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (application == null) {
      final args = ArgumentHelper.getArgument<Map>(
        context,
        routeName: AppRoutes.adminDetail,
      );

      if (args != null && args['application'] != null) {
        application = args['application'] as ApplicationModel;
      }
    }
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.adminDetail);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (application == null) {
      return Scaffold(
        appBar: const HeaderWidget(showBackButton: true),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryBlue),
          ),
        ),
      );
    }

    final app = application!;

    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: _isProcessing
          ? const Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(
              AppConstants.primaryBlue),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                app.statusColor.withOpacity(0.1),
                borderRadius:
                BorderRadius.circular(12),
                border: Border.all(
                    color: app.statusColor),
              ),
              child: Row(
                children: [
                  Icon(
                    app.status ==
                        ApplicationStatus.pending
                        ? Icons.pending
                        : app.status ==
                        ApplicationStatus
                            .approved
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: app.statusColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'Current Status: ${app.statusText}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            app.statusColor,
                          ),
                        ),
                        Text(
                          'Applied on: ${app.appliedDate.day}/${app.appliedDate.month}/${app.appliedDate.year}',
                          style:
                          const TextStyle(
                            fontSize: 14,
                            color: AppConstants
                                .textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSection(
              'Application Information',
              [
                _buildInfoRow(
                    'Application ID', app.id),
                _buildInfoRow('Service Name',
                    app.serviceName),
                _buildInfoRow(
                    'Fee Amount',
                    '₹${app.amount?.toStringAsFixed(2) ?? 'N/A'}'),
                if (app.paymentId != null)
                  _buildInfoRow(
                      'Payment ID',
                      app.paymentId!),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              'Applicant Details',
              [
                _buildInfoRow(
                    'Name',
                    app.formData['name'] ??
                        'N/A'),
                _buildInfoRow(
                    'Father\'s Name',
                    app.formData['fatherName'] ??
                        'N/A'),
                _buildInfoRow(
                    'Date of Birth',
                    app.formData['dob'] ??
                        'N/A'),
                _buildInfoRow(
                    'Gender',
                    app.formData['gender'] ??
                        'N/A'),
                _buildInfoRow(
                    'Mobile',
                    app.formData['mobile'] ??
                        'N/A'),
                _buildInfoRow(
                    'Email',
                    app.formData['email'] ??
                        'N/A'),
                _buildInfoRow(
                    'Address',
                    app.formData['address'] ??
                        'N/A',
                    maxLines: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.buttonShadow,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppConstants.textMedium,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppConstants.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}