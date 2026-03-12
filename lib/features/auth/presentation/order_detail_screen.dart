import 'package:flutter/material.dart';
// Import your model to resolve the PurchaseRecord class
import '../domain/purchase_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final PurchaseRecord record;
  const OrderDetailScreen({super.key, required this.record});

  // Function to simulate PDF generation
  void _generateInvoice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Preparing your Legacy Invoice..."),
        backgroundColor: Color(0xFF121212),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(record.orderId,
            style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.productName.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
            const SizedBox(height: 10),
            Text("STATUS: ${record.status}",
                style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white10, height: 40),
            _buildDetailRow("Amount Paid", "₹${record.amountPaid}"),
            _buildDetailRow("Date", "${record.purchaseDate.day}/${record.purchaseDate.month}/${record.purchaseDate.year}"),
          ],
        ),
      ),
      // Luxury Download Button added to the bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFD4AF37)),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: () => _generateInvoice(context),
          child: const Text(
            "DOWNLOAD LEGACY INVOICE",
            style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}