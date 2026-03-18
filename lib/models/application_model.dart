import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum ApplicationStatus { pending, approved, rejected, paymentPending }

class ApplicationModel {
  final String id;
  final String userId;
  final String serviceName;
  final DateTime appliedDate;
  final ApplicationStatus status;
  final Map<String, dynamic> formData;
  final List<String> documentUrls;
  final double? amount;
  final String? paymentId;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.appliedDate,
    required this.status,
    required this.formData,
    required this.documentUrls,
    this.amount,
    this.paymentId,
  });

  String get statusText {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.paymentPending:
        return 'Payment Pending';
    }
  }

  Color get statusColor {
    switch (status) {
      case ApplicationStatus.pending:
        return AppConstants.primaryOrange;
      case ApplicationStatus.approved:
        return AppConstants.successGreen;
      case ApplicationStatus.rejected:
        return AppConstants.errorRed;
      case ApplicationStatus.paymentPending:
        return Colors.amber;
    }
  }
}