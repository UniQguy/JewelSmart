import 'package:flutter/material.dart';
import '../domain/purchase_model.dart';
import '../domain/repositories/purchase_repository.dart';
import '../data/repositories/mock_purchase_repository.dart';
import 'order_detail_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  // Instantiate the repository.
  final PurchaseRepository _repository = MockPurchaseRepository();

  // --- LOGIC HANDLERS ---

  void _handleLogout(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // --- SETTINGS MODAL LOGIC ---

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("PREFERENCES",
                  style: TextStyle(
                      color: Colors.white, fontSize: 10, letterSpacing: 4)),
              const SizedBox(height: 25),
              _buildSettingsOption(Icons.person_edit_outlined, "Edit Profile", () {
                Navigator.pop(context); // Close bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              }),
              _buildSettingsOption(Icons.notifications_none_outlined, "Notifications", () {}),
              _buildSettingsOption(Icons.security_outlined, "Privacy & Security", () {}),
              const Divider(color: Colors.white10, height: 40),
              _buildSettingsOption(
                  Icons.logout,
                  "Logout",
                      () => _handleLogout(context),
                  isDestructive: true
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsOption(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive ? Colors.redAccent : luxuryGold, size: 20),
      title: Text(title,
          style: TextStyle(
              color: isDestructive ? Colors.redAccent : Colors.white,
              fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 12),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildProfileHeader()),
          const SliverPadding(
            padding: EdgeInsets.all(25),
            sliver: SliverToBoxAdapter(
              child: Text("PURCHASE HISTORY",
                  style: TextStyle(
                      color: Colors.white24,
                      fontSize: 9,
                      letterSpacing: 5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          FutureBuilder<List<PurchaseRecord>>(
            // Call the repository method here
            future: _repository.getPurchaseHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                      child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
                );
              } else if (snapshot.hasError) {
                return const SliverToBoxAdapter(
                  child: Center(
                      child: Text("Error loading history",
                          style: TextStyle(color: Colors.red))),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                      child: Text("No purchases found",
                          style: TextStyle(color: Colors.white24))),
                );
              }
              return _buildHistoryList(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<PurchaseRecord> history) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final item = history[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(record: item),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  border: Border.all(color: Colors.white10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName,
                          style: const TextStyle(color: Colors.white, fontSize: 11)),
                      Text(item.orderId,
                          style: const TextStyle(color: Colors.white24, fontSize: 9)),
                    ],
                  ),
                  Text(item.status,
                      style: TextStyle(
                          color: luxuryGold,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
        childCount: history.length,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const SizedBox(height: 30),
        CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.05),
            child: Icon(Icons.person_outline, color: luxuryGold, size: 40)),
        const SizedBox(height: 20),
        const Text("PRASHANT",
            style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 4)),
        Text("VALUED CUSTOMER",
            style: TextStyle(color: luxuryGold, fontSize: 9, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 0,
      floating: true,
      title: const Text("LEGACY PROFILE",
          style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 5)),
      actions: [
        IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: Colors.white38, size: 18),
            onPressed: () => _showSettingsMenu(context))
      ],
    );
  }
}