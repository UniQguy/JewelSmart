import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// THE IDENTITY MATRIX (USER MANAGEMENT)
/// Engineered as a high-clearance terminal to manipulate user roles and vault access.
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // GLASSMORPHIC ROLE MODIFICATION ATELIER
  void _showEditRoleSheet(BuildContext context, String userId, String currentRole, String currentStatus, String userName) {
    String tempRole = currentRole.isNotEmpty ? currentRole : 'Customer';
    String tempStatus = currentStatus.isNotEmpty ? currentStatus : 'Active';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600), // Web Scaler
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        border: Border(
                          top: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                          left: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                          right: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Container(width: 40, height: 2, color: Colors.white24)),
                          const SizedBox(height: 30),
                          Text("MODIFY CLEARANCE: ${userName.toUpperCase()}", style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 6, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 40),

                          _buildSheetLabel("ASSIGN PROTOCOL ROLE"),
                          _buildSheetOptions(['Customer', 'Staff', 'Admin'], tempRole, (val) => setSheetState(() => tempRole = val)),
                          const SizedBox(height: 40),

                          _buildSheetLabel("VAULT ACCESS STATUS"),
                          _buildSheetOptions(['Active', 'Inactive'], tempStatus, (val) => setSheetState(() => tempStatus = val), isStatus: true),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: luxuryGold, width: 0.5),
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                backgroundColor: luxuryGold.withValues(alpha: 0.1),
                              ),
                              onPressed: () async {
                                HapticFeedback.mediumImpact();
                                Navigator.pop(context);
                                await _updateUserClearance(userId, tempRole, tempStatus);
                              },
                              child: const Text("ENFORCE CLEARANCE UPDATE", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 6)),
    );
  }

  Widget _buildSheetOptions(List<String> options, String current, Function(String) onSelect, {bool isStatus = false}) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        itemBuilder: (context, index) {
          bool isSelected = current == options[index];
          Color activeColor = isStatus && options[index] == 'Inactive' ? Colors.redAccent : luxuryGold;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(options[index]);
            },
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.08), width: 0.5),
                boxShadow: isSelected ? [BoxShadow(color: activeColor.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 1)] : [],
              ),
              child: Center(
                child: Text(
                  options[index].toUpperCase(),
                  style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 4),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateUserClearance(String userId, String role, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': role,
        'status': status,
      });
      if (mounted) _showNotification("CLEARANCE OVERRIDE SUCCESSFUL", isError: false);
    } catch (e) {
      if (mounted) _showNotification("OVERRIDE FAILED", isError: true);
    }
  }

  void _showNotification(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isError ? Colors.redAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                    border: Border.all(color: isError ? Colors.redAccent.withValues(alpha: 0.5) : luxuryGold.withValues(alpha: 0.5), width: 0.5),
                  ),
                  child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(context),
      body: Stack(
        children: [
          _buildAmbientGlow(),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000), // Wide Web Scaler
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLiquidSearchBar(),
                    Expanded(child: _buildUserMatrixStream()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiquidAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context);
              },
            ),
            title: Text('IDENTITY MATRIX', style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 10)),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      bottom: -100,
      right: -50,
      child: Container(
        width: 400, height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 120, spreadRadius: 40)],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildLiquidSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w300),
              cursorColor: luxuryGold,
              decoration: InputDecoration(
                hintText: "SEARCH IDENTITIES...",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 9, letterSpacing: 5, fontWeight: FontWeight.bold),
                prefixIcon: Icon(Icons.search_rounded, color: luxuryGold.withValues(alpha: 0.6), size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildUserMatrixStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("NO IDENTITIES FOUND", style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8)));
        }

        final users = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['name'] ?? '').toString().toLowerCase();
          final email = (data['email'] ?? '').toString().toLowerCase();
          return name.contains(_searchQuery) || email.contains(_searchQuery);
        }).toList();

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildUserTile(doc.id, data),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildUserTile(String userId, Map<String, dynamic> data) {
    final name = data['name'] ?? 'UNKNOWN';
    final email = data['email'] ?? 'NO CONTACT';
    final role = data['role'] ?? 'Customer';
    final status = data['status'] ?? 'Active';
    final isInactive = status == 'Inactive';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border(
          left: BorderSide(color: isInactive ? Colors.redAccent : luxuryGold.withValues(alpha: 0.8), width: 2),
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showEditRoleSheet(context, userId, role, status, name),
              highlightColor: luxuryGold.withValues(alpha: 0.1),
              splashColor: luxuryGold.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Icon(
                      role == 'Admin' ? Icons.admin_panel_settings : (role == 'Staff' ? Icons.badge : Icons.person_outline),
                      color: isInactive ? Colors.redAccent.withValues(alpha: 0.5) : luxuryGold.withValues(alpha: 0.8),
                      size: 24,
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name.toString().toUpperCase(), style: TextStyle(color: isInactive ? Colors.white38 : Colors.white, fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 6),
                          Text(email.toString().toLowerCase(), style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(role.toString().toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isInactive ? Colors.redAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                            border: Border.all(color: isInactive ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1), width: 0.5),
                          ),
                          child: Text(status.toString().toUpperCase(), style: TextStyle(color: isInactive ? Colors.redAccent : Colors.white70, fontSize: 6, letterSpacing: 2, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}