import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // CRITICAL: Added for Haptic Feedback
import 'package:flutter_riverpod/flutter_riverpod.dart'; // CRITICAL: Added to listen to the Wishlist Provider
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/product_model.dart';

// Import the Wishlist Engine we just built
import '../../../wishlist/providers/wishlist_provider.dart';

/// THE LUXURY EXHIBIT CARD
/// Engineered with counter-scaling parallax, volumetric gradients, dynamic light glare,
/// and a live-wired Curation (Wishlist) Engine.
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
    // Trigger the light glare sweep
    _glareController.forward(from: 0.0);
  }

  void _handlePressUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handlePressCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handlePressDown,
      onTapUp: _handlePressUp,
      onTapCancel: _handlePressCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0, // Card pulls back into the Z-axis
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(0), // High-fashion sharp edges
            border: Border.all(
              color: _isPressed ? luxuryGold.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.08),
              width: 0.5,
            ),
            boxShadow: [
              if (_isPressed)
                BoxShadow(
                    color: luxuryGold.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: -10
                )
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. CINEMATIC IMAGE WITH 3D HERO TRANSITION & CLOUD LOADING
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'product_image_${widget.product.id}',
                          child: ClipRect(
                            child: AnimatedScale(
                              scale: _isPressed ? 1.08 : 1.0, // Image pushes outward (Parallax)
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutExpo,
                              child: _buildNetworkImage(),
                            ),
                          ),
                        ),
                        // Volumetric shadow gradient to ensure text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.9)
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. EDITORIAL TYPOGRAPHY DETAILS
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 7,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.product.formattedPrice,
                          style: TextStyle(
                              color: luxuryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 2
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. DYNAMIC PHYSICAL GLARE EFFECT
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

              // 4. THE LIVE CURATION HEART (WISHLIST INTERACTION)
              Positioned(
                top: 10,
                right: 10,
                child: Consumer(
                  builder: (context, ref, child) {
                    // Watch the global wishlist state
                    final wishlist = ref.watch(wishlistProvider);
                    final isSaved = wishlist.any((p) => p.id == widget.product.id);

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact(); // Tactile feedback
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
                            ).animate(target: isSaved ? 1 : 0) // Subtle pulse when activated
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

  /// Handles fetching the image from Cloudinary with a cinematic fallback
  Widget _buildNetworkImage() {
    // If the image URL is completely missing, show a sleek placeholder
    if (widget.product.imageUrl.isEmpty) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.2), size: 40),
        ),
      );
    }

    return Image.network(
      widget.product.imageUrl,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child; // Image is fully loaded

        // Premium Loading State
        return Container(
          color: Colors.black,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: luxuryGold.withValues(alpha: 0.5),
                strokeWidth: 1,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 800.ms);
      },
      errorBuilder: (context, error, stackTrace) {
        // Fallback if the Cloudinary link breaks
        return Container(
          color: Colors.black,
          child: Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.white.withValues(alpha: 0.1), size: 30),
          ),
        );
      },
    );
  }
}