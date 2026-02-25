import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product_model.dart';
import '../data/report_service.dart';
// REQUIRED: Import AuthService to handle the Logout procedure
import '../data/auth_service.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  void _handleRoleUpdate(String userName, String currentRole) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFD4AF37), width: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("MANAGE ROLE: $userName",
                style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 3)),
            const SizedBox(height: 30),
            _roleOption("Admin", currentRole == "Admin"),
            _roleOption("Staff", currentRole == "Staff"),
            _roleOption("Customer", currentRole == "Customer"),
          ],
        ),
      ),
    );
  }

  Widget _roleOption(String role, bool isCurrent) {
    return ListTile(
      title: Text(role.toUpperCase(),
          style: TextStyle(color: isCurrent ? luxuryGold : Colors.white38, fontSize: 10, letterSpacing: 2)),
      trailing: isCurrent ? Icon(Icons.check, color: luxuryGold, size: 16) : null,
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: luxuryGold,
            content: Text("ROLE UPDATED TO $role", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  void _handleGenerateReport() {
    final salesReport = ReportService.generateSalesReport(mockProducts);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(side: BorderSide(color: luxuryGold.withOpacity(0.3))),
        title: Text(salesReport.type,
            style: TextStyle(color: luxuryGold, letterSpacing: 4, fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _reportText("Report ID: ${salesReport.reportId}"),
            _reportText("Generated: ${salesReport.generatedDate.toString().split('.')[0]}"),
            const Divider(color: Colors.white10, height: 30),
            _reportText("Inventory Items: ${salesReport.data['total_sku_count']}"),
            _reportText("Valuation: \$${salesReport.data['inventory_valuation']}"),
            _reportText("Estimated GST (3%): \$${salesReport.data['tax_estimate']}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("DISMISS", style: TextStyle(color: luxuryGold, letterSpacing: 2, fontSize: 10)),
          )
        ],
      ),
    );
  }

  Widget _reportText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w300)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAdminAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("EXECUTIVE OVERVIEW"),
            _buildReportMetrics(),
            const SizedBox(height: 40),
            _buildSectionLabel("SYSTEM ADMINISTRATION"),
            _buildAdminActions(),
            const SizedBox(height: 40),
            _buildSectionLabel("RECENT USER ACTIVITY"),
            _buildUserTablePreview(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAdminAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text('ADMINISTRATIVE VAULT',
          style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 6, fontWeight: FontWeight.w200)),
      actions: [
        IconButton(
          icon: const Icon(Icons.power_settings_new_rounded, color: Colors.white38, size: 18),
          // Procedure Sync: Triggers the Logout Use Case for Admin
          onPressed: () => AuthService().signOut(),
        ),
      ],
    );
  }

  Widget _buildReportMetrics() {
    return Row(
      children: [
        _metricCard("TOTAL REVENUE", "\$1.2M", Icons.payments_outlined),
        const SizedBox(width: 15),
        _metricCard("ACTIVE USERS", "1,204", Icons.people_outline),
      ],
    );
  }

  Widget _metricCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          border: Border.all(color: luxuryGold.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: luxuryGold, size: 20),
            const SizedBox(height: 15),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w100)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions() {
    return Column(
      children: [
        _actionTile(Icons.person_add_alt_1_outlined, "MANAGE USERS & ROLES", () {}),
        _actionTile(Icons.analytics_outlined, "GENERATE ANALYTICAL REPORTS", _handleGenerateReport),
        _actionTile(Icons.settings_suggest_outlined, "SYSTEM CONFIGURATION", () {}),
      ],
    );
  }

  Widget _actionTile(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), border: Border.all(color: Colors.white10)),
      child: ListTile(
        leading: Icon(icon, color: luxuryGold, size: 18),
        title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 3, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white10, size: 14),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUserTablePreview() {
    final List<Map<String, String>> mockUsers = [
      {"name": "PRASHANT", "role": "Admin", "status": "Active"},
      {"name": "STAFF_MEMBER_01", "role": "Staff", "status": "Active"},
      {"name": "CLIENT_DE-44", "role": "Customer", "status": "Inactive"},
    ];

    return Column(
      children: mockUsers.map((user) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.01),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text(user['role']!.toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 2)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white38, size: 18),
              onPressed: () => _handleRoleUpdate(user['name']!, user['role']!),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 4)),
    );
  }
}