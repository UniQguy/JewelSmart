import 'package:flutter/material.dart';
import '../../domain/product_model.dart'; // REQUIRED: For the updated Product definition

class LuxuryProductCard extends StatefulWidget {
  // FIXED: Accepts the full Product object instead of individual strings
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

class _LuxuryProductCardState extends State<LuxuryProductCard> {
  bool _isPressed = false;
  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isPressed ? luxuryGold.withOpacity(0.4) : Colors.white10,
              width: 0.8,
            ),
            boxShadow: [
              if (_isPressed)
                BoxShadow(
                    color: luxuryGold.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 2
                )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. IMAGE WITH HERO TRANSITION (Using unique productId from table)
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product_image_${widget.product.productId}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          widget.product.imagePath, // Dynamic path from Dictionary
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. EDITORIAL TYPOGRAPHY DETAILS
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // DISPLAY: Uses the Business Logic calculation for price
                    Text(
                      widget.product.formattedPrice,
                      style: TextStyle(
                          color: luxuryGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}