class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  Future<String?> initiatePayment(double amount, String orderId) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock payment initiation
    return 'payment_link_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<bool> verifyPayment(String paymentId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock payment verification
    return true;
  }

  Future<String> generateReceipt(String paymentId, double amount, String orderId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'RECEIPT_${DateTime.now().millisecondsSinceEpoch}';
  }
}