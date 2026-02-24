import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Your existing imports maintained
import 'cart/providers/cart_provider.dart';
import 'auth/presentation/home_page.dart';
import 'auth/presentation/search_screen.dart';
import 'cart/presentation/cart_page.dart';
import 'profile/presentation/profile_page.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final Color luxuryGold = const Color(0xFFD4AF37);

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

  // Handle dock taps with smooth sliding animation
  // Handle dock taps with smooth sliding animation
  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      // Fixed the error: tightForCurve does not exist
      curve: Curves.easeInOutCubic, // Provides a premium, smooth deceleration
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watching your REAL cart count provider
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true, // Crucial: Content flows behind the glass dock
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),

      // THE FLOATING GLASS NAV BAR
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), // Increased blur
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_outlined, Icons.home_rounded, 0),
                  _navItem(Icons.search_rounded, Icons.search_rounded, 1),

                  // Passing real count to the badge
                  _navItem(
                    Icons.shopping_bag_outlined,
                    Icons.shopping_bag_rounded,
                    2,
                    showBadge: cartCount > 0,
                    count: cartCount,
                  ),

                  _navItem(Icons.person_outline, Icons.person_rounded, 3),
                ],
              ),
            ),
          ),
        ),
      ),

      // Your existing test button kept for convenience
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90), // Moved up so it doesn't block the dock
        child: FloatingActionButton(
          backgroundColor: luxuryGold,
          mini: true,
          onPressed: () {
            ref.read(cartProvider.notifier).update((state) => [...state, 'New Jewel']);
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, int index, {bool showBadge = false, int count = 0}) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? luxuryGold.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? luxuryGold : Colors.white38,
              size: isActive ? 28 : 24, // Subtle size pop
            ),
          ),

          if (showBadge)
            Positioned(
              top: 5,
              right: 5,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                  child: child,
                ),
                child: Container(
                  key: ValueKey<int>(count),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: luxuryGold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: luxuryGold.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}