import 'package:cloud_firestore/cloud_firestore.dart'; // REQUIRED: For User Table sync
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // REQUIRED

  // Email/Password Login
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Account Creation: Automatically sets default role to 'Customer'
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        await _syncUserToFirestore(result.user!, 'Customer'); //
      }
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Google Authentication: Fast-track login for Customer actor
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // Logic Sync: Checks if user exists; if not, creates 'Customer' entry
        await _syncUserToFirestore(result.user!, 'Customer');
      }

      return result.user;
    } catch (e) {
      debugPrint("Google Auth Error: $e");
      return null;
    }
  }

  // Helper: Synchronizes Firebase Auth with USER TABLE schema
  Future<void> _syncUserToFirestore(User user, String defaultRole) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'New Member',
        'role': defaultRole, // Fulfills AuthWrapper requirement
        'status': 'Active',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
}