import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Core Feature Imports
import 'cart/providers/cart_provider.dart';
import 'auth/presentation/home_page.dart';
import 'auth/presentation/search_screen.dart';
import 'cart/presentation/cart_page.dart';
import 'profile/presentation/profile_page.dart';

/// THE ARCHITECTURAL STAGE: MainWrapper
/// Implements high-end spatial depth and global glassmorphism.
class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final Color luxuryGold = const Color(0xFFD4AF37);

  // Define the main navigation pages
  final List<Widget> _pages = [
    const HomePage(),
    const SearchScreen(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    // FIXED: Swapped nonexistent curve to a premium built-in curve
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic, // Modern premium easing
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch cart state for real-time badge updates
    final cartItems = ref.watch(cartProvider);
    final int cartCount = cartItems.length;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true, // Crucial for glassmorphic overlap
      body: Stack(
        children: [
          // 1. GLOBAL BACKGROUND DEPTH LAYER
          // This layer persists through all page transitions to maintain 3D spatial feel
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    luxuryGold.withValues(alpha: 0.08), // FIXED: withOpacity to withValues
                    Colors.black,
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 2.seconds),

          // 2. LIQUID CONTENT LAYER
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            physics: const BouncingScrollPhysics(),
            children: _pages,
          ),

          // 3. FLOATING GLASS NAVIGATION DOCK
          _buildGlassDock(cartCount),
        ],
      ),
    );
  }

  Widget _buildGlassDock(int cartCount) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0), // Signature square "Editorial" edges
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25), // Ultra-soft frost effect
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03), // FIXED: withOpacity to withValues
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08), // FIXED: withOpacity to withValues
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 0, "STUDIO"),
                _buildNavItem(Icons.search, 1, "SEARCH"),
                _buildNavItem(Icons.shopping_bag_outlined, 2, "VAULT", count: cartCount),
                _buildNavItem(Icons.person_outline, 3, "IDENTITY"),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.5, end: 0);
  }

  Widget _buildNavItem(IconData icon, int index, String label, {int count = 0}) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isActive ? luxuryGold : Colors.white24,
                  size: 22,
                ).animate(target: isActive ? 1 : 0).shimmer(color: luxuryGold.withValues(alpha: 0.5)), // FIXED: withOpacity to withValues

                // Dynamic Notification Badge
                if (count > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: luxuryGold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: luxuryGold.withValues(alpha: 0.4), // FIXED: withOpacity to withValues
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Center(
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 200.ms),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Minimalist active indicator label
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isActive ? 1.0 : 0.0,
              child: Text(
                label,
                style: TextStyle(
                  color: luxuryGold,
                  fontSize: 7,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}