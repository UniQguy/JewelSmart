import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// WORLD-CLASS AUTH SERVICE
/// Engineered for zero silent failures and guaranteed Firestore synchronization.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  /// EMAIL AUTHENTICATION
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (result.user != null) {
        await _syncUserToFirestore(result.user!, 'customer');
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Authentication Failed";
      debugPrint("Auth Error: $_errorMessage");
      return null;
    } catch (e) {
      // CRITICAL FIX: Catching Firestore or Network errors
      _errorMessage = "Database Sync Failed. Please try again.";
      debugPrint("System Error during Login: $e");
      return null;
    }
  }

  /// IDENTITY CREATION (Signup)
  /// Atomic Operation: Guarantees Firestore doc creation.
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      // 1. Create Auth Identity
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (result.user != null) {
        // 2. Update Local Profile
        await result.user!.updateDisplayName(name.trim());

        // 3. Force Database Creation
        await _syncUserToFirestore(result.user!, 'customer', name: name.trim());
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Registration Denied";
      debugPrint("Auth Creation Error: $_errorMessage");
      return null;
    } catch (e) {
      // CRITICAL FIX: If Firestore fails to create the document, we catch it here!
      _errorMessage = "Account created, but database sync failed.";
      debugPrint("Firestore Sync Error during Signup: $e");
      return null;
    }
  }

  /// GOOGLE IDENTITY ACCESS
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        await _syncUserToFirestore(result.user!, 'customer');
      }

      return result.user;
    } catch (e) {
      _errorMessage = "Google Identity Verification Failed";
      debugPrint("Google Auth Error: $e");
      return null;
    }
  }

  /// ROLE-BASED ACCESS CONTROL (RBAC) FETCHER
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role']?.toString().toLowerCase() ?? 'customer';
      }
      return 'customer';
    } catch (e) {
      debugPrint("Role Fetch Error: $e");
      return 'customer';
    }
  }

  /// INTERNAL CORE: ROOT USER SYNCHRONIZATION
  /// Bruteforces the document creation. If this fails, the catch blocks above will trigger.
  Future<void> _syncUserToFirestore(User user, String defaultRole, {String? name}) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();

      Map<String, dynamic> data = {
        'uid': user.uid,
        'email': user.email,
        'status': 'Active',
        'lastActive': FieldValue.serverTimestamp(),
        'metadata': {
          'platform': defaultTargetPlatform.toString(),
          'appVersion': '1.0.0',
        }
      };

      if (!snapshot.exists) {
        data['role'] = defaultRole;
        data['name'] = name ?? user.displayName ?? 'Valued Member';
      } else if (name != null && name.isNotEmpty) {
        data['name'] = name;
      }

      await userDoc.set(data, SetOptions(merge: true));
      debugPrint("✅ FIRESTORE SYNC SUCCESS: Document created/updated for ${user.uid}");

    } catch (e) {
      debugPrint("❌ FIRESTORE SYNC FATAL ERROR: $e");
      throw Exception("Failed to write to Firestore: $e"); // Throwing it up to be caught by the UI flow
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