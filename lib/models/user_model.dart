class UserModel {
  final String aadhaarNumber;
  final String name;
  final String? email;
  final String? phone;
  final bool isAdmin;

  UserModel({
    required this.aadhaarNumber,
    required this.name,
    this.email,
    this.phone,
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() => {
    'aadhaarNumber': aadhaarNumber,
    'name': name,
    'email': email,
    'phone': phone,
    'isAdmin': isAdmin,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    aadhaarNumber: json['aadhaarNumber'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    isAdmin: json['isAdmin'] ?? false,
  );
}