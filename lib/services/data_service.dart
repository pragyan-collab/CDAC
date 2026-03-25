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
        title: 'PM Kisan',
        description: 'Financial assistance for farmers',
        eligibility: 'Small and marginal farmers',
        benefits: 'Regular income support',
        documents: 'Aadhaar, KYC documents',
        applicationProcess: 'Apply via official portal',
        department: 'Department of Agriculture',
        lastDate: DateTime.now().add(const Duration(days: 60)),
      ),
      SchemeModel(
        id: 'SCM002',
        title: 'Ayushman Bharat',
        description: 'Health insurance coverage for eligible families',
        eligibility: 'As per government eligibility criteria',
        benefits: 'Cashless healthcare services',
        documents: 'Aadhaar, eligibility proof',
        applicationProcess: 'Apply/verify via portal',
        department: 'Ministry of Health',
        lastDate: DateTime.now().add(const Duration(days: 45)),
      ),
      SchemeModel(
        id: 'SCM003',
        title: 'Digital India',
        description: 'Digital services and empowerment',
        eligibility: 'Citizens seeking digital services',
        benefits: 'Access to digital infrastructure',
        documents: 'Basic identity documents',
        applicationProcess: 'Follow scheme instructions',
        department: 'Ministry of Electronics',
        lastDate: DateTime.now().add(const Duration(days: 90)),
      ),
      SchemeModel(
        id: 'SCM004',
        title: 'Startup India',
        description: 'Support for startups and entrepreneurs',
        eligibility: 'Startups registered/recognized',
        benefits: 'Funding, mentorship and support',
        documents: 'Business registration documents',
        applicationProcess: 'Apply through startup portal',
        department: 'DPIIT',
        lastDate: DateTime.now().add(const Duration(days: 75)),
      ),
      SchemeModel(
        id: 'SCM005',
        title: 'Skill India',
        description: 'Enhance skills for employability',
        eligibility: 'Youth and job seekers',
        benefits: 'Training and certification',
        documents: 'Aadhaar and education details',
        applicationProcess: 'Register for training program',
        department: 'Ministry of Skill Development',
        lastDate: DateTime.now().add(const Duration(days: 120)),
      ),
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