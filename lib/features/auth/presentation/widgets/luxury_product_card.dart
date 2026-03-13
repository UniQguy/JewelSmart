import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/product_model.dart';

/// THE LUXURY EXHIBIT CARD
/// Engineered with counter-scaling parallax, volumetric gradients, and dynamic light glare.
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
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(0), // High-fashion sharp edges
            border: Border.all(
              color: _isPressed ? luxuryGold.withOpacity(0.8) : Colors.white.withOpacity(0.08),
              width: 0.5,
            ),
            boxShadow: [
              if (_isPressed)
                BoxShadow(
                    color: luxuryGold.withOpacity(0.2),
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
                  // 1. CINEMATIC IMAGE WITH 3D HERO TRANSITION
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'product_image_${widget.product.productId}',
                          child: ClipRect(
                            child: AnimatedScale(
                              scale: _isPressed ? 1.08 : 1.0, // Image pushes outward (Parallax)
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutExpo,
                              child: Image.asset(
                                widget.product.imagePath,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
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
                                Colors.black.withOpacity(0.9)
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
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}