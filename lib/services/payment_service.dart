import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final Razorpay _razorpay = Razorpay();
  final String _baseUrl = 'http://10.0.2.2:8000/api/payment';

  Razorpay get instance => _razorpay;

  Future<String?> initiatePayment(double amount, String contextId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final response = await http.post(
        Uri.parse('\$_baseUrl/create-order/'),
        headers: {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer \$token'},
        body: jsonEncode({'amount': amount.toString(), 'context_id': contextId}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body)['id'];
      return null;
    } catch (e) { return null; }
  }

  Future<bool> verifyPayment(String paymentId) async {
    return true; // Simplified for Hackathon demonstration
  }

  Future<String> generateReceipt(String paymentId, double amount, String orderId) async {
    await Future.delayed(const Duration(seconds: 1));
    final receiptNo = 'RECEIPT_${DateTime.now().millisecondsSinceEpoch}';
    return receiptNo;
  }
}