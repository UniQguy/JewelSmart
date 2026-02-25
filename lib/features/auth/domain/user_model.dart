class UserProfile {
  final int userId; // Primary Key
  final String name; //
  final String email; //
  final String role; // Admin/Staff/Customer
  final String status; // Active/Inactive

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.status = "Active",
  });

  // Checkers for Role-Based Use Cases [cite: 18, 56]
  bool get isAdmin => role == 'Admin';
  bool get isStaff => role == 'Staff';
  bool get isCustomer => role == 'Customer';
}