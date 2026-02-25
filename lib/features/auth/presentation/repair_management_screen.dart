import 'package:flutter/material.dart';
// FIXED: Mandatory import to resolve the RepairOrder definition
import '../domain/repair_model.dart';

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
        itemDescription: "22K Gold Chain",
        issue: "Clasp Replacement",
        status: "Pending",
        estimatedCost: 1200.0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // UI Sync: Matches the ethereal luxury aesthetic
        title: const Text("REPAIR REGISTRY",
            style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 5, fontWeight: FontWeight.w300)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.itemDescription,
                        style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1)),
                    const SizedBox(height: 5),
                    Text("Issue: ${order.issue}",
                        style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
                _statusBadge(order.status),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: luxuryGold.withOpacity(0.5)),
      ),
      child: Text(status.toUpperCase(),
          style: TextStyle(color: luxuryGold, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }
}