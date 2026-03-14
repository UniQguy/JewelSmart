import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// THE VAULT LOGISTICS TERMINAL (ACTIVE ORDERS)
/// Engineered to monitor and mutate the fulfillment state of high-value acquisitions.
class ActiveOrdersScreen extends StatefulWidget {
  const ActiveOrdersScreen({super.key});

  @override
  State<ActiveOrdersScreen> createState() => _ActiveOrdersScreenState();
}

class _ActiveOrdersScreenState extends State<ActiveOrdersScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // GLASSMORPHIC LOGISTICS MUTATION ATELIER
  void _showEditStatusSheet(BuildContext context, String orderId, String currentStatus, String artifactName) {
    String tempStatus = currentStatus.isNotEmpty ? currentStatus.toUpperCase() : 'PROCESSING';

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
                      height: MediaQuery.of(context).size.height * 0.55,
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
                          Text("LOGISTICS PROTOCOL", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 10),
                          Text(artifactName.toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.w100)),
                          const SizedBox(height: 40),

                          _buildSheetLabel("CURRENT FULFILLMENT STATE"),
                          _buildSheetOptions(['PROCESSING', 'IN TRANSIT', 'SECURED'], tempStatus, (val) => setSheetState(() => tempStatus = val)),

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
                                await _updateOrderStatus(orderId, tempStatus);
                              },
                              child: const Text("ENFORCE LOGISTICS UPDATE", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold)),
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

  Widget _buildSheetOptions(List<String> options, String current, Function(String) onSelect) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        itemBuilder: (context, index) {
          bool isSelected = current == options[index];

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
                color: isSelected ? luxuryGold : Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: isSelected ? luxuryGold : Colors.white.withValues(alpha: 0.08), width: 0.5),
                boxShadow: isSelected ? [BoxShadow(color: luxuryGold.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 1)] : [],
              ),
              child: Center(
                child: Text(
                  options[index],
                  style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 4),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('purchases').doc(orderId).update({
        'status': status,
      });
      if (mounted) _showNotification("LOGISTICS STATE UPDATED", isError: false);
    } catch (e) {
      if (mounted) _showNotification("SYNC FAILED", isError: true);
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
                    Expanded(child: _buildOrderMatrixStream()),
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
            title: Text('VAULT LOGISTICS', style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 10)),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: -50,
      left: -100,
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
                hintText: "SEARCH HASH IDs OR ARTIFACTS...",
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

  Widget _buildOrderMatrixStream() {
    return StreamBuilder<QuerySnapshot>(
      // Sorting by most recent acquisitions first
      stream: FirebaseFirestore.instance.collection('purchases').orderBy('purchaseDate', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("NO ACTIVE ACQUISITIONS", style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8)));
        }

        final orders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final artifactName = (data['productName'] ?? '').toString().toLowerCase();
          final hashId = doc.id.toLowerCase();
          return artifactName.contains(_searchQuery) || hashId.contains(_searchQuery);
        }).toList();

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildOrderTile(doc.id, data),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderTile(String orderId, Map<String, dynamic> data) {
    final artifactName = data['productName'] ?? 'UNKNOWN ARTIFACT';
    final amountPaid = (data['amountPaid'] ?? 0.0) as num;
    final status = (data['status'] ?? 'PROCESSING').toString().toUpperCase();

    // Formatting the date
    final timestamp = data['purchaseDate'] as Timestamp?;
    final dateString = timestamp != null ? timestamp.toDate().toString().substring(0, 10) : 'N/A';

    // Status aesthetics
    final bool isSecured = status == 'SECURED' || status == 'DELIVERED';
    final bool isTransit = status == 'IN TRANSIT';
    final Color statusColor = isSecured ? luxuryGold : (isTransit ? Colors.blueAccent : Colors.white54);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border(
          left: BorderSide(color: statusColor.withValues(alpha: 0.8), width: 2),
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
              onTap: () => _showEditStatusSheet(context, orderId, status, artifactName),
              highlightColor: luxuryGold.withValues(alpha: 0.1),
              splashColor: luxuryGold.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor,
                                boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.5), blurRadius: 5)],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(status, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 4)),
                          ],
                        ),
                        Text(dateString, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, letterSpacing: 2)),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                    ),

                    // Artifact Details
                    Text(artifactName, style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 3, fontWeight: FontWeight.w200)),
                    const SizedBox(height: 15),

                    // Footer Row: Hash & Currency (INR format applied)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("HASH ID", style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 6, letterSpacing: 2, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(orderId.toUpperCase(), style: const TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace')),
                          ],
                        ),
                        Text("₹${amountPaid.toStringAsFixed(2)}", style: TextStyle(color: luxuryGold, fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: 1)),
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