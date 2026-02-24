import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// FIXED PATHS: Go up two levels to reach presentation folder

import 'home_page.dart';
import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    const Color luxuryGold = Color(0xFFD4AF37);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [luxuryGold.withOpacity(0.05), Colors.black],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomePage(); // Now it can find this class
        }

        return const LoginPage(); // Now it can find this class
      },
    );
  }
}