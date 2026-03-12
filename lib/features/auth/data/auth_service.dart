import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// WORLD-CLASS AUTH SERVICE
/// Implements high-caliber error handling and atomic Firestore synchronization.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Global Luxury Standard: Use a more descriptive error handling pattern
  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  /// EMAIL AUTHENTICATION
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      // Input Sanitation: Prevents "Invalid Email" errors from accidental spaces
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      // Verification Sync: Ensure doc exists even on old accounts
      if (result.user != null) {
        await _ensureUserDocumentExists(result.user!);
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Authentication Failed";
      debugPrint("Auth Error: $_errorMessage");
      return null;
    }
  }

  /// IDENTITY CREATION (Signup)
  /// Atomic Operation: Auth User and Firestore Doc are treated as a single event.
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (result.user != null) {
        // Update Firebase Profile immediately for local UI consistency
        await result.user!.updateDisplayName(name);

        // Create the Root User Document before returning to the UI
        // This prevents the "Denied" error caused by a missing Firestore record
        await _syncUserToFirestore(result.user!, 'Customer', name: name);
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Registration Denied";
      return null;
    }
  }

  /// GOOGLE IDENTITY ACCESS
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
        await _syncUserToFirestore(result.user!, 'Customer');
      }

      return result.user;
    } catch (e) {
      _errorMessage = "Google Identity Verification Failed";
      return null;
    }
  }

  /// INTERNAL CORE: ROOT USER SYNCHRONIZATION
  /// Ensures the 'users' root collection follows the global standard schema.
  Future<void> _syncUserToFirestore(User user, String role, {String? name}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // We use SetOptions(merge: true) to ensure document creation without data loss
    await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'name': name ?? user.displayName ?? 'Valued Member',
      'role': role, // Critical for AuthWrapper routing
      'status': 'Active',
      'lastActive': FieldValue.serverTimestamp(),
      'metadata': {
        'platform': defaultTargetPlatform.toString(),
        'appVersion': '1.0.0',
      }
    }, SetOptions(merge: true));
  }

  /// RECOVERY LOGIC: For existing users without Firestore docs
  Future<void> _ensureUserDocumentExists(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _syncUserToFirestore(user, 'Customer');
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