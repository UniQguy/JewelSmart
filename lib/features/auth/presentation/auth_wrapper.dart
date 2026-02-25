import 'package:cloud_firestore/cloud_firestore.dart'; // REQUIRED: For role-fetching
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Procedure Sync: Transitions to different dashboards based on Role
import 'home_page.dart';
import 'login_page.dart';
import 'staff_dashboard.dart';
import 'admin_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    const Color luxuryGold = Color(0xFFD4AF37);

    return StreamBuilder<User?>(
      // Sequence Sync: Validates user session against database
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. SYSTEM INITIALIZING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingScreen(luxuryGold);
        }

        // 2. AUTHENTICATED STATE
        if (snapshot.hasData) {
          final User user = snapshot.data!;

          // Logic Sync: Fetches the "Role" field from USER TABLE schema
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return _loadingScreen(luxuryGold);
              }

              // Default to 'Customer' if document or role field is missing
              String role = 'Customer';
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>;
                role = data['role'] ?? 'Customer';
              }

              // Role-Based Routing Logic
              if (role == "Admin") {
                return const AdminDashboard();
              } else if (role == "Staff") {
                return const StaffDashboard();
              } else {
                return const HomePage(); // Default for Customer actor
              }
            },
          );
        }

        // 3. LOGGED OUT STATE: Redirect to Login UI
        return const LoginPage();
      },
    );
  }

  // Helper to maintain luxury aesthetic during transitions
  Widget _loadingScreen(Color color) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: color, strokeWidth: 2),
      ),
    );
  }
}