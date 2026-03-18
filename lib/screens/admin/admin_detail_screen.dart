import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../services/data_service.dart';
import '../../widgets/header_widget.dart';
import '../../models/application_model.dart';

class AdminDetailScreen extends StatefulWidget {
  const AdminDetailScreen({Key? key}) : super(key: key);

  @override
  State<AdminDetailScreen> createState() => _AdminDetailScreenState();
}

class _AdminDetailScreenState extends State<AdminDetailScreen> {
  late ApplicationModel application;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    application = args['application'];
  }

  Future<void> _updateStatus(ApplicationStatus status) async {
    setState(() {
      _isProcessing = true;
    });

    await DataService().updateApplicationStatus(application.id, status);

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application ${status == ApplicationStatus.approved ? 'Approved' : 'Rejected'}'),
        backgroundColor: status == ApplicationStatus.approved
            ? AppConstants.successGreen
            : AppConstants.errorRed,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: _isProcessing
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: application.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: application.statusColor),
              ),
              child: Row(
                children: [
                  Icon(
                    application.status == ApplicationStatus.pending
                        ? Icons.pending
                        : application.status == ApplicationStatus.approved
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: application.statusColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Status: ${application.statusText}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: application.statusColor,
                          ),
                        ),
                        Text(
                          'Applied on: ${application.appliedDate.day}/${application.appliedDate.month}/${application.appliedDate.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Application Info
            _buildSection(
              'Application Information',
              [
                _buildInfoRow('Application ID', application.id),
                _buildInfoRow('Service Name', application.serviceName),
                _buildInfoRow('Fee Amount', '₹${application.amount?.toStringAsFixed(2) ?? 'N/A'}'),
                if (application.paymentId != null)
                  _buildInfoRow('Payment ID', application.paymentId!),
              ],
            ),

            const SizedBox(height: 16),

            // Applicant Details
            _buildSection(
              'Applicant Details',
              [
                _buildInfoRow('Name', application.formData['name'] ?? 'N/A'),
                _buildInfoRow('Father\'s Name', application.formData['fatherName'] ?? 'N/A'),
                _buildInfoRow('Date of Birth', application.formData['dob'] ?? 'N/A'),
                _buildInfoRow('Gender', application.formData['gender'] ?? 'N/A'),
                _buildInfoRow('Mobile', application.formData['mobile'] ?? 'N/A'),
                _buildInfoRow('Email', application.formData['email'] ?? 'N/A'),
                _buildInfoRow('Address', application.formData['address'] ?? 'N/A', maxLines: 3),
              ],
            ),

            const SizedBox(height: 16),

            // Documents
            _buildSection(
              'Uploaded Documents',
              application.documentUrls.map((url) {
                return ListTile(
                  leading: const Icon(Icons.description, color: AppConstants.primaryBlue),
                  title: Text(url),
                  trailing: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      // View document
                    },
                  ),
                );
              }).toList(),
            ),

            if (application.status == ApplicationStatus.pending) ...[
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(ApplicationStatus.approved),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.successGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(ApplicationStatus.rejected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.errorRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Remarks
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Remarks (Optional)',
                  hintText: 'Add any comments or remarks...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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

  Widget _buildInfoRow(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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