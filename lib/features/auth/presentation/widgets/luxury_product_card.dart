import 'package:flutter/material.dart';

class LuxuryProductCard extends StatefulWidget {
  final String title;
  final String price;
  final VoidCallback onTap;

  const LuxuryProductCard({
    super.key,
    required this.title,
    required this.price,
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
        scale: _isPressed ? 0.95 : 1.0, // Physical "press" effect
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
              // 1. IMAGE WITH SOFT VIGNETTE
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(
                        'assets/images/login_bg.jpg', // Your default placeholder
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Glassmorphic overlay for image depth
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
                      widget.title.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3 // High-end tracking
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.price,
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