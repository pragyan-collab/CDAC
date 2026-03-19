// lib/screens/user/upload_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../utils/argument_helper.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/safe_navigation.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, File?> uploadedFiles = {
    'photo': null,
    'aadhaar': null,
    'address': null,
    'income': null,
    'other': null,
  };

  bool _isUploading = false;
  Map<String, dynamic>? formData;
  String? serviceName;

  final List<Map<String, String>> requiredDocuments = [
    {'key': 'photo', 'name': 'Passport Size Photo', 'icon': '📸'},
    {'key': 'aadhaar', 'name': 'Aadhaar Card', 'icon': '🆔'},
    {'key': 'address', 'name': 'Address Proof', 'icon': '🏠'},
    {'key': 'income', 'name': 'Income Certificate', 'icon': '💰'},
    {'key': 'other', 'name': 'Other Documents', 'icon': '📄'},
  ];

  bool _argsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      _argsLoaded = true;
      _getArguments();
    }
  }

  void _getArguments() {
    final args = ArgumentHelper.getArgument<Map>(
      context,
      routeName: AppRoutes.upload,
    );
    if (args != null) {
      formData = args['formData'] as Map<String, dynamic>?;
      serviceName = args['service'] as String?;
    }
  }

  Future<void> _pickImage(String documentKey) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppConstants.primaryBlue),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 80,
                  );
                  if (image != null && mounted) {
                    setState(() {
                      uploadedFiles[documentKey] = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppConstants.primaryOrange),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 80,
                  );
                  if (image != null && mounted) {
                    setState(() {
                      uploadedFiles[documentKey] = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitApplication() async {
    if (uploadedFiles['photo'] == null || uploadedFiles['aadhaar'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least Photo and Aadhaar Card'),
          backgroundColor: AppConstants.errorRed,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isUploading = false);

    if (serviceName?.contains('Certificate') ?? false) {
      SafeNavigation.navigateTo(
        AppRoutes.payment,
        arguments: {
          'amount': 100.0,
          'serviceName': serviceName,
          'applicationId': 'APP${DateTime.now().millisecondsSinceEpoch}',
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully!'),
          backgroundColor: AppConstants.successGreen,
        ),
      );
      SafeNavigation.navigateReplacementTo(AppRoutes.status);
    }
  }

  @override
  void dispose() {
    ArgumentHelper.clearArguments(AppRoutes.upload);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(showBackButton: true),
      body: _isUploading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
            ),
            SizedBox(height: 16),
            Text(
              'Uploading documents...',
              style: TextStyle(
                color: AppConstants.textMedium,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppConstants.buttonShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Service: $serviceName',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppConstants.textMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Applicant: ${formData?['name']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppConstants.textMedium,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Required Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload clear images of the following documents',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textMedium,
              ),
            ),
            const SizedBox(height: 20),

            ...requiredDocuments.map((doc) {
              final isUploaded = uploadedFiles[doc['key']] != null;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppConstants.buttonShadow,
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? AppConstants.successGreen.withOpacity(0.1)
                          : AppConstants.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      doc['icon']!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(
                    doc['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    isUploaded ? 'Uploaded' : 'Not uploaded',
                    style: TextStyle(
                      color: isUploaded ? AppConstants.successGreen : AppConstants.errorRed,
                      fontSize: 12,
                    ),
                  ),
                  trailing: isUploaded
                      ? IconButton(
                    icon: const Icon(Icons.check_circle, color: AppConstants.successGreen),
                    onPressed: () => _pickImage(doc['key']!),
                  )
                      : ElevatedButton(
                    onPressed: () => _pickImage(doc['key']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryOrange,
                      foregroundColor: AppConstants.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Upload'),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.successGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Application',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: AppConstants.primaryBlue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Maximum file size: 5MB. Supported formats: JPG, PNG, PDF',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.textMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}