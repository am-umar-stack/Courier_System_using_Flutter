enum UserRole { admin, driver, customer, warehouse }

class User {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final UserRole role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'].toString().toLowerCase(),
        orElse: () => UserRole.customer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.name,
    };
  }
}
