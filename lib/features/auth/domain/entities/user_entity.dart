class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.createdAt,
  });

  bool get isCustomer => role == 'customer';
  bool get isRider => role == 'rider';

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserEntity) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
