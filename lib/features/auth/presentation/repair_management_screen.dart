import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// REQUIRED: Ensure this points correctly to your domain model
import '../domain/repair_model.dart';

/// THE REPAIR REGISTRY (STAFF INTERFACE)
/// Engineered as a secure, glassmorphic ledger for internal artisan management.
class RepairManagementScreen extends StatefulWidget {
  const RepairManagementScreen({super.key});

  @override
  State<RepairManagementScreen> createState() => _RepairManagementScreenState();
}

class _RepairManagementScreenState extends State<RepairManagementScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  // Procedure Sync: Fulfills "Manage Repair Orders" use case for Staff
  final List<RepairOrder> orders = [
    RepairOrder(
        repairId: 881,
        customerName: "Prashant",
        itemDescription: "22K GOLD CHAIN",
        issue: "Clasp Replacement",
        status: "Pending",
        estimatedCost: 1200.0
    ),
    RepairOrder(
        repairId: 882,
        customerName: "Aarav",
        itemDescription: "DIAMOND TENNIS BRACELET",
        issue: "Stone Resetting",
        status: "In Progress",
        estimatedCost: 8500.0
    ),
    RepairOrder(
        repairId: 883,
        customerName: "Meera",
        itemDescription: "ANTIQUE SILVER CHOKER",
        issue: "Polishing & Oxidation Removal",
        status: "Completed",
        estimatedCost: 450.0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Crucial for spatial depth
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Cinematic 3D Background
          _buildAmbientBackground(),

          // 2. Main Ledger Interface
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(context),
                const SizedBox(height: 20),

                // 3. Staggered Glassmorphic Registry List
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildRepairCard(orders[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.5,
            colors: [
              luxuryGold.withOpacity(0.08),
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
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("INTERNAL SYSTEM", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("REPAIR REGISTRY", style: TextStyle(color: luxuryGold, fontSize: 14, letterSpacing: 4, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildRepairCard(RepairOrder order) {
    // Dynamic styling based on status
    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.greenAccent;
        break;
      case 'in progress':
        statusColor = luxuryGold;
        break;
      default:
        statusColor = Colors.orangeAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "ORDER #${order.repairId}",
                        style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 3, fontWeight: FontWeight.bold)
                    ),
                    _statusBadge(order.status, statusColor),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
                ),
                Text(
                    order.itemDescription.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w300)
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.build_circle_outlined, color: luxuryGold.withOpacity(0.5), size: 14),
                    const SizedBox(width: 8),
                    Text(
                        order.issue.toUpperCase(),
                        style: const TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 2)
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("CLIENT", style: TextStyle(color: Colors.white24, fontSize: 7, letterSpacing: 4, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(order.customerName.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 2)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("EST. COST", style: TextStyle(color: Colors.white24, fontSize: 7, letterSpacing: 4, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("\$${order.estimatedCost.toStringAsFixed(2)}", style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Text(
          status.toUpperCase(),
          style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 2)
      ),
    );
  }
}