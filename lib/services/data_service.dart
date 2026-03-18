import '../models/application_model.dart';
import '../models/scheme_model.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<ApplicationModel> _applications = [];
  List<SchemeModel> _schemes = [];

  // Mock data initialization
  void initMockData() {
    _applications = [
      ApplicationModel(
        id: 'APP001',
        userId: '123456789012',
        serviceName: 'Birth Certificate',
        appliedDate: DateTime.now().subtract(const Duration(days: 2)),
        status: ApplicationStatus.pending,
        formData: {'name': 'Test', 'dob': '01-01-2000'},
        documentUrls: ['doc1.pdf'],
        amount: 100.0,
      ),
      // Add more mock applications
    ];

    _schemes = [
      SchemeModel(
        id: 'SCM001',
        title: 'PM Awas Yojana',
        description: 'Housing for All by 2024',
        eligibility: 'Family income less than 3 lakhs',
        benefits: 'Subsidy up to 2.67 lakhs',
        documents: 'Aadhaar, Income Certificate, etc.',
        applicationProcess: 'Online application through portal',
        department: 'Ministry of Housing',
        lastDate: DateTime.now().add(const Duration(days: 30)),
      ),
      // Add more mock schemes
    ];
  }

  List<ApplicationModel> getUserApplications(String userId) {
    return _applications.where((app) => app.userId == userId).toList();
  }

  List<ApplicationModel> getPendingApplications() {
    return _applications.where((app) => app.status == ApplicationStatus.pending).toList();
  }

  Future<void> updateApplicationStatus(String appId, ApplicationStatus status) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _applications.indexWhere((app) => app.id == appId);
    if (index != -1) {
      _applications[index] = ApplicationModel(
        id: _applications[index].id,
        userId: _applications[index].userId,
        serviceName: _applications[index].serviceName,
        appliedDate: _applications[index].appliedDate,
        status: status,
        formData: _applications[index].formData,
        documentUrls: _applications[index].documentUrls,
        amount: _applications[index].amount,
        paymentId: _applications[index].paymentId,
      );
    }
  }

  List<SchemeModel> getSchemes() => _schemes;

  Future<void> addApplication(ApplicationModel application) async {
    await Future.delayed(const Duration(seconds: 1));
    _applications.add(application);
  }
}