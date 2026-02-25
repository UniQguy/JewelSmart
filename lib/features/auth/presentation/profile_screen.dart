import 'package:flutter/material.dart';
// FIXED: Added the mandatory import to resolve the PurchaseRecord class
import '../domain/purchase_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    // Procedure Sync: Represents the "Update Purchase History" state in the Activity Diagram
    final List<PurchaseRecord> history = [
      PurchaseRecord(
          orderId: "JS-99281",
          purchaseDate: DateTime(2026, 2, 10),
          productName: "Ethereal Emerald Ring",
          amountPaid: 45000.00,
          status: "SECURED"
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverPadding(
            padding: const EdgeInsets.all(25),
            sliver: SliverToBoxAdapter(
              child: Text("PURCHASE HISTORY",
                  style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 5, fontWeight: FontWeight.bold)),
            ),
          ),
          _buildHistoryList(history),
        ],
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
            child: Icon(Icons.person_outline, color: luxuryGold, size: 40)
        ),
        const SizedBox(height: 20),
        // Personalization Sync: Uses name from the established User Summary
        const Text("PRASHANT", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 4)),
        Text("VALUED CUSTOMER", style: TextStyle(color: luxuryGold, fontSize: 9, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildHistoryList(List<PurchaseRecord> history) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final item = history[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), border: Border.all(color: Colors.white10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    Text(item.orderId, style: const TextStyle(color: Colors.white24, fontSize: 9)),
                  ],
                ),
                Text(item.status, style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
        childCount: history.length,
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 0,
      floating: true,
      title: const Text("LEGACY PROFILE", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 5)),
      actions: [
        IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white38, size: 18),
            onPressed: () {}
        )
      ],
    );
  }
}