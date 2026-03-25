import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application_model.dart';
import '../models/scheme_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator alias over localhost

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<List<ApplicationModel>> getPendingApplications() async {
    return []; // Mock list for now
  }

  List<SchemeModel> getSchemes() {
    return [
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
    ];
  }

  Future<String> sendChatMessage(String message, String lang) async {
    try {
      final response = await http.post(
        Uri.parse('\$baseUrl/chatbot/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"message": message, "language": lang}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['reply'];
      }
      return "Network Error Responses.";
    } catch (e) {
      return "Connection Failed.";
    }
  }
}

final apiService = ApiService();