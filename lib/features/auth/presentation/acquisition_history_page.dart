import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../auth/domain/purchase_model.dart';
import '../../auth/domain/repositories/purchase_repository.dart';
import '../../auth/domain/repositories/mock_purchase_repository.dart';
import '../../auth/presentation/order_detail_screen.dart';

class AcquisitionHistoryPage extends StatelessWidget {
  AcquisitionHistoryPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);
  final PurchaseRepository _repository = MockPurchaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("ACQUISITION HISTORY",
            style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 5, fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Subtle background matching your theme
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF0A0A0A)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: FutureBuilder<List<PurchaseRecord>>(
              future: _repository.getPurchaseHistory('user_123'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1));
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error retrieving records.", style: TextStyle(color: Colors.redAccent)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("THE VAULT IS EMPTY", style: TextStyle(color: Colors.white24, letterSpacing: 4)));
                }

                return _buildAnimatedList(snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedList(List<PurchaseRecord> history) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 40.0,
              child: FadeInAnimation(
                child: _buildHistoryCard(context, item),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, PurchaseRecord item) {
    return GestureDetector(
      onTap: () {
        // FIXED: Changed parameter name from 'record' to 'purchase' to match OrderDetailScreen
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(purchase: item)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          // FIXED: Updated deprecated .withOpacity to .withValues(alpha: ...)
          color: Colors.white.withValues(alpha: 0.02),
          border: Border.all(color: Colors.white10, width: 0.5),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName.toUpperCase(),
                          style: const TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 5),
                      Text(item.orderId, style: const TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 2)),
                    ],
                  ),
                  Text(item.status, style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}