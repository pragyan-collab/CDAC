import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application_model.dart';
import '../models/scheme_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ✅ Use your PC IP (IMPORTANT)
  final String baseUrl = 'http://192.168.1.15:8000/api';

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
        title: 'PM Awas Yojana',
        description: 'Housing',
        eligibility: '',
        benefits: '',
        documents: '',
        applicationProcess: '',
        department: 'Ministry',
        lastDate: DateTime.now(),
      )
    ];
  }

  Future<String> sendChatMessage(String message, String lang) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatbot/'), // ✅ FIXED interpolation
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "message": message,
          "language": lang,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['reply'];
      } else {
        return "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Connection Failed: $e";
    }
  }
}

final apiService = ApiService();