import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_routes.dart'; // REQUIRED: For navigation
import '../domain/product_model.dart';
import '../../cart/providers/inventory_provider.dart';
import '../data/invoice_service.dart';
import '../data/auth_service.dart';

class StaffDashboard extends ConsumerStatefulWidget {
  const StaffDashboard({super.key});

  @override
  ConsumerState<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends ConsumerState<StaffDashboard> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  void _handleGenerateInvoice(Product product) {
    final invoice = InvoiceService.generateInvoice(product, 101);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(side: BorderSide(color: luxuryGold.withOpacity(0.3))),
        title: Text("DIGITAL INVOICE",
            style: TextStyle(color: luxuryGold, letterSpacing: 5, fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _invoiceText("Invoice ID: #JS-${invoice.invoiceId.toString().substring(8)}"),
            _invoiceText("Date: ${invoice.date.toString().split(' ')[0]}"),
            const Divider(color: Colors.white10, height: 30),
            _invoiceText("Item: ${product.title}"),
            _invoiceText("Metal: ${product.purity}"),
            _invoiceText("Total Payable: \$${invoice.amount.toStringAsFixed(2)}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("FINALIZE & PRINT", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 2)),
          )
        ],
      ),
    );
  }

  Widget _invoiceText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w300)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventory = ref.watch(inventoryProvider);
    final totalUnits = inventory.values.fold(0, (sum, item) => sum + item);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildStaffAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCards(totalUnits),
            const SizedBox(height: 30),
            const Text("INVENTORY MANAGEMENT",
                style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(child: _buildInventoryList(inventory)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildStaffAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text('STAFF CONTROL PANEL',
          style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 5, fontWeight: FontWeight.w300)),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white38, size: 18),
          onPressed: () => AuthService().signOut(),
        ),
      ],
    );
  }

  Widget _buildStatCards(int totalUnits) {
    return Row(
      children: [
        _statItem("TOTAL STOCK", "$totalUnits Units"),
        const SizedBox(width: 15),
        // Procedure Sync: Linking the card to Manage Repair Orders Use Case
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.repairManagement),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                border: Border.all(color: luxuryGold.withOpacity(0.4)), // Highlighted interactive border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PENDING REPAIRS", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2)),
                  const SizedBox(height: 10),
                  Text("08", style: TextStyle(color: luxuryGold, fontSize: 18, fontWeight: FontWeight.w100)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), border: Border.all(color: Colors.white10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2)),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(color: luxuryGold, fontSize: 18, fontWeight: FontWeight.w100)),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryList(Map<int, int> inventory) {
    return ListView.builder(
      itemCount: mockProducts.length,
      itemBuilder: (context, index) {
        final product = mockProducts[index];
        final currentStock = inventory[product.productId] ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
          child: Row(
            children: [
              Image.asset(product.imagePath, width: 50, height: 50, fit: BoxFit.cover),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1)),
                    Text("Stock: $currentStock Units",
                        style: TextStyle(color: currentStock < 5 ? Colors.red : luxuryGold, fontSize: 9)),
                  ],
                ),
              ),
              _inventoryAction(Icons.receipt_long_outlined, () => _handleGenerateInvoice(product)),
              const SizedBox(width: 10),
              _inventoryAction(Icons.remove, () {
                ref.read(inventoryProvider.notifier).stockOut(product.productId, 1);
                _showStatus(product.title, "Decreased");
              }),
              const SizedBox(width: 10),
              _inventoryAction(Icons.add, () {
                ref.read(inventoryProvider.notifier).stockIn(product.productId, 1);
                _showStatus(product.title, "Increased");
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _inventoryAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: Colors.white24)),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }

  void _showStatus(String title, String action) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: luxuryGold,
        duration: const Duration(milliseconds: 500),
        content: Text("STOCK $action FOR $title",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
      ),
    );
  }
}