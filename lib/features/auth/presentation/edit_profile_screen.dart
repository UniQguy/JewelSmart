import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// THE IDENTITY MODIFICATION TERMINAL (EDIT PROFILE)
/// Engineered as a highly secure, spatial glassmorphic interface connected to Live Firestore.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 1. PULL REAL DATA FROM SECURE VAULT
  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _emailController.text = user.email ?? "UNKNOWN CREDENTIAL";

        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _nameController.text = doc.data()?['name'] ?? "";
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch user data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 2. PUSH REAL DATA TO FIREBASE
  Future<void> _saveChanges() async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
        });

        if (mounted) {
          _showSecureNotification("IDENTITY PROFILE UPDATED");
          await Future.delayed(const Duration(milliseconds: 1000));
          // SAFE POP: Prevents the blank white screen error
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      _showSecureNotification("SYNC FAILED: CHECK CONNECTION", isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSecureNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isError ? Colors.redAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: isError ? Colors.redAccent.withValues(alpha: 0.5) : luxuryGold.withValues(alpha: 0.5), width: 0.5),
              ),
              child: Text(
                message,
                style: TextStyle(color: isError ? Colors.redAccent : Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Crucial for spatial depth
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Cinematic 3D Background
          _buildAmbientBackground(),

          // 2. Main Interface
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 40),

                // Frosted Glass Terminal
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5))
                      : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: _buildModificationTerminal(),
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Action Bar
          if (!_isLoading) _buildBottomActionPanel(),

          // 4. Processing Overlay
          if (_isSaving) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.4),
            radius: 1.5,
            colors: [
              luxuryGold.withValues(alpha: 0.12),
              Colors.black,
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
                // SAFE ROUTING: Prevents white screen crashes
                onPressed: () => Navigator.maybePop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("IDENTITY MANAGEMENT", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("EDIT LEGACY PROFILE", style: TextStyle(color: luxuryGold, fontSize: 14, letterSpacing: 4, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildModificationTerminal() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0), // High-fashion square edges
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditorialField("FULL LEGAL NAME", Icons.person_outline_rounded, _nameController),
              const SizedBox(height: 35),
              // Email is locked to prevent Auth desync crashes
              _buildEditorialField("MEMBER IDENTIFICATION (LOCKED)", Icons.lock_outline_rounded, _emailController, isReadOnly: true),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEditorialField(String label, IconData icon, TextEditingController controller, {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: TextStyle(color: isReadOnly ? Colors.white24 : Colors.white38, fontSize: 7, letterSpacing: 5, fontWeight: FontWeight.w900)
        ),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          style: TextStyle(color: isReadOnly ? Colors.white38 : Colors.white, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w300),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(icon, color: isReadOnly ? Colors.white24 : luxuryGold.withValues(alpha: 0.6), size: 18),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: isReadOnly ? Colors.white.withValues(alpha: 0.1) : luxuryGold, width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 45), // Extra padding for iOS home bar
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
            ),
            child: GestureDetector(
              onTap: _saveChanges,
              child: Container(
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                  color: luxuryGold.withValues(alpha: 0.9),
                  border: Border.all(color: luxuryGold, width: 1),
                  boxShadow: [
                    BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 10))
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                        "SECURE IDENTITY UPDATES",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 9)
                    ),
                    // Sweeping light effect
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.4), Colors.white.withValues(alpha: 0.0)],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: false))
                          .slideX(begin: -2.0, end: 2.0, duration: 3.seconds, curve: Curves.easeInOutSine),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0.0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildProcessingOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
          ),
        ),
      ),
    );
  }
}