import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/product_model.dart';
import '../../../wishlist/providers/wishlist_provider.dart';

/// THE LUXURY EXHIBIT CARD
/// Engineered with counter-scaling parallax, volumetric gradients, dynamic light glare,
/// and a secure hidden Management Terminal for Admins/Staff.
class LuxuryProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const LuxuryProductCard({
    super.key,
    required this.product,
    required this.onTap
  });

  @override
  State<LuxuryProductCard> createState() => _LuxuryProductCardState();
}

class _LuxuryProductCardState extends State<LuxuryProductCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _glareController;

  @override
  void initState() {
    super.initState();
    _glareController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600)
    );
  }

  @override
  void dispose() {
    _glareController.dispose();
    super.dispose();
  }

  void _handlePressDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _glareController.forward(from: 0.0);
  }

  void _handlePressUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handlePressCancel() {
    setState(() => _isPressed = false);
  }

  // --- THE SECRET MANAGEMENT TERMINAL ---
  void _handleLongPress() {
    setState(() => _isPressed = false);
    HapticFeedback.heavyImpact();
    _showManagementTerminal(context);
  }

  void _showManagementTerminal(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    border: Border(
                      top: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                      left: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                      right: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                    ),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37), strokeWidth: 1.5)));
                      }

                      String role = 'customer';
                      if (snapshot.hasData && snapshot.data!.exists) {
                        role = (snapshot.data!.get('role') ?? 'customer').toString().toLowerCase();
                      }

                      if (role != 'admin' && role != 'staff') {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.gpp_bad_outlined, color: Colors.redAccent.withValues(alpha: 0.8), size: 40),
                                const SizedBox(height: 20),
                                const Text("CLEARANCE DENIED", style: TextStyle(color: Colors.redAccent, fontSize: 10, letterSpacing: 6, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start, // FIXED: Capital C
                        children: [
                          Center(child: Container(width: 40, height: 2, color: Colors.white24)),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("VAULT MANAGEMENT", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 6, fontWeight: FontWeight.w900)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: luxuryGold.withValues(alpha: 0.1), border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5)),
                                child: Text(role.toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 6, letterSpacing: 2, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(widget.product.title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w200)),
                          const SizedBox(height: 40),

                          const Text("LOGISTICS CONTROL (STOCK)", style: TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 5)),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: _buildAdminButton("DECREMENT", Icons.remove_circle_outline, Colors.orangeAccent, () => _updateStock(-1)),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildAdminButton("INCREMENT", Icons.add_circle_outline, Colors.greenAccent, () => _updateStock(1)),
                              ),
                            ],
                          ),

                          if (role == 'admin') ...[
                            const SizedBox(height: 40),
                            const Text("DESTRUCTIVE ACTIONS", style: TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 5)),
                            const SizedBox(height: 15),
                            _buildAdminButton("PERMANENTLY DELETE ARTIFACT", Icons.delete_forever_outlined, Colors.redAccent, () {
                              _deleteArtifact();
                              Navigator.pop(context);
                            }),
                          ],
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: color, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStock(int change) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(widget.product.id).update({
        'stock': FieldValue.increment(change)
      });
    } catch (e) {
      debugPrint("Stock Update Failed: $e");
    }
  }

  Future<void> _deleteArtifact() async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(widget.product.id).delete();
    } catch (e) {
      debugPrint("Deletion Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handlePressDown,
      onTapUp: _handlePressUp,
      onTapCancel: _handlePressCancel,
      onLongPress: _handleLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: _isPressed ? luxuryGold.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.08),
              width: 0.5,
            ),
            boxShadow: [
              if (_isPressed)
                BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: -10)
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'product_image_${widget.product.id}',
                          child: ClipRect(
                            child: AnimatedScale(
                              scale: _isPressed ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutExpo,
                              child: _buildNetworkImage(),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title.toUpperCase(),
                                style: const TextStyle(color: Colors.white54, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 4),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "QTY: ${widget.product.stock}",
                              style: TextStyle(color: widget.product.stock <= 0 ? Colors.redAccent : Colors.white24, fontSize: 6, fontWeight: FontWeight.bold, letterSpacing: 2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.product.formattedPrice,
                          style: TextStyle(color: luxuryGold, fontSize: 14, fontWeight: FontWeight.w200, letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              AnimatedBuilder(
                  animation: _glareController,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-2.0 + (_glareController.value * 4), -1.0),
                              end: Alignment(-1.0 + (_glareController.value * 4), 1.0),
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),

              Positioned(
                top: 10,
                right: 10,
                child: Consumer(
                  builder: (context, ref, child) {
                    final wishlist = ref.watch(wishlistProvider);
                    final isSaved = wishlist.any((p) => p.id == widget.product.id);

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ref.read(wishlistProvider.notifier).toggleWishlist(widget.product);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isSaved ? luxuryGold.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
                                  width: 0.5
                              ),
                            ),
                            child: Icon(
                              isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isSaved ? luxuryGold : Colors.white70,
                              size: 14,
                            ).animate(target: isSaved ? 1 : 0)
                                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 200.ms, curve: Curves.easeOutBack),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    if (widget.product.imageUrl.isEmpty) {
      return Container(color: Colors.black, child: Center(child: Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.2), size: 40)));
    }

    return Image.network(
      widget.product.imageUrl,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.black,
          child: Center(
            child: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                color: luxuryGold.withValues(alpha: 0.5),
                strokeWidth: 1,
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) : null,
              ),
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 800.ms);
      },
      errorBuilder: (context, error, stackTrace) => Container(color: Colors.black, child: Center(child: Icon(Icons.broken_image_outlined, color: Colors.white.withValues(alpha: 0.1), size: 30))),
    );
  }
}