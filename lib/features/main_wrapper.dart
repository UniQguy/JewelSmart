import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Corrected paths based on your folder tree
import 'cart/providers/cart_provider.dart';
import 'auth/presentation/home_page.dart';
import 'auth/presentation/search_screen.dart';
import 'cart/presentation/cart_page.dart';
import 'profile/presentation/profile_page.dart';

// 3. Change StatefulWidget to ConsumerStatefulWidget to use Riverpod in state
class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  int _currentIndex = 0;
  final Color luxuryGold = const Color(0xFFD4AF37);

  final List<Widget> _pages = [
    const HomePage(),
    const SearchScreen(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // 4. Watch the cartCountProvider to get the live count
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // THE FLOATING GLASS NAV BAR
          Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white10, width: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(Icons.home_outlined, Icons.home, 0),
                      _navItem(Icons.search_rounded, Icons.search, 1),

                      // 5. Pass the REAL cartCount to the nav item
                      _navItem(
                        Icons.shopping_bag_outlined,
                        Icons.shopping_bag,
                        2,
                        showBadge: cartCount > 0,
                        count: cartCount,
                      ),

                      _navItem(Icons.person_outline, Icons.person, 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // 6. Updated TEST BUTTON to use Riverpod logic
      floatingActionButton: FloatingActionButton(
        backgroundColor: luxuryGold,
        mini: true,
        onPressed: () {
          // Access the provider and update the list
          ref.read(cartProvider.notifier).update((state) => [...state, 'New Jewel']);
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // Added 'count' parameter to the helper method
  Widget _navItem(IconData icon, IconData activeIcon, int index, {bool showBadge = false, int count = 0}) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? luxuryGold.withOpacity(0.12) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? luxuryGold : Colors.white38,
              size: 26,
            ),
          ),

          if (showBadge)
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                  child: child,
                ),
                child: Container(
                  key: ValueKey<int>(count), // Uses the REAL count for animation
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: luxuryGold,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    '$count',
                    style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900),
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