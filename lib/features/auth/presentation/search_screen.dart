import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Core Imports
import '../../../core/router/app_routes.dart';
import '../domain/product_model.dart';
import '../providers/product_provider.dart';
import 'widgets/luxury_product_card.dart';

/// THE DISCOVERY ENGINE (SEARCH)
/// Engineered as a liquid, glassmorphic search interface connected to the live Firestore matrix.
/// FIXED: Deep-Index Searching, Expanded Luxury Price Caps, and Flexible Metadata Matching.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _searchController = TextEditingController();

  String _selectedStone = 'All';
  String _selectedMetal = 'All';
  String _searchQuery = '';

  // CRITICAL FIX: Luxury scaling. Default max price is now 50 Lakhs to prevent hiding high-end items.
  double _maxPrice = 5000000.0;

  final List<String> stones = ['All', 'Emerald', 'Diamond', 'Ruby', 'Sapphire', 'Pearl'];
  final List<String> metals = ['All', '24K', '22K', '18K', '14K', 'Platinum', 'Silver'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- THE DEEP SEARCH ENGINE ---
  List<Product> _getFilteredProducts(List<Product> sourceProducts) {
    return sourceProducts.where((product) {

      // 1. Flexible Stone Matching (Checks Title, Description, and Category)
      final matchesStone = _selectedStone == 'All' ||
          product.title.toUpperCase().contains(_selectedStone.toUpperCase()) ||
          product.description.toUpperCase().contains(_selectedStone.toUpperCase()) ||
          product.category.toUpperCase().contains(_selectedStone.toUpperCase());

      // 2. Flexible Metal/Purity Matching
      final purityString = "${product.purity.toInt()}K";
      final matchesMetal = _selectedMetal == 'All' ||
          purityString == _selectedMetal.toUpperCase() ||
          product.title.toUpperCase().contains(_selectedMetal.toUpperCase()) ||
          product.description.toUpperCase().contains(_selectedMetal.toUpperCase());

      // 3. DEEP INDEX SEARCH (Fixes Issue #5)
      // Now scans Title, Category, and Description simultaneously.
      final safeQuery = _searchQuery.trim().toLowerCase();
      final matchesSearch = safeQuery.isEmpty ||
          product.title.toLowerCase().contains(safeQuery) ||
          product.category.toLowerCase().contains(safeQuery) ||
          product.description.toLowerCase().contains(safeQuery);

      // 4. Accurate Price Valuation
      final double totalPrice = product.price + product.makingCharges;
      final matchesPrice = totalPrice <= _maxPrice;

      return matchesStone && matchesMetal && matchesSearch && matchesPrice;
    }).toList();
  }

  // --- THE HIDDEN ATELIER (FILTERS) ---
  void _showFilterAtelier(BuildContext context) {
    String tempStone = _selectedStone;
    String tempMetal = _selectedMetal;
    double tempPrice = _maxPrice;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
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
                          Text("PARAMETRIC FILTERS", style: TextStyle(color: luxuryGold, fontSize: 14, letterSpacing: 8, fontWeight: FontWeight.w100)),
                          const SizedBox(height: 30),

                          _buildSheetLabel("STONES"),
                          _buildSheetOptions(stones, tempStone, (val) => setSheetState(() => tempStone = val)),
                          const SizedBox(height: 30),

                          _buildSheetLabel("PURITY & METAL"),
                          _buildSheetOptions(metals, tempMetal, (val) => setSheetState(() => tempMetal = val)),
                          const SizedBox(height: 30),

                          _buildSheetLabel("ACQUISITION LIMIT: ₹${tempPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}"),
                          const SizedBox(height: 10),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 1.0,
                              activeTrackColor: luxuryGold,
                              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                              thumbColor: luxuryGold,
                              overlayColor: luxuryGold.withValues(alpha: 0.1),
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                            ),
                            child: Slider(
                              value: tempPrice,
                              min: 10000,
                              max: 5000000, // Up to 50 Lakhs
                              divisions: 50,
                              onChanged: (val) => setSheetState(() => tempPrice = val),
                            ),
                          ),

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
                              onPressed: () {
                                setState(() {
                                  _selectedStone = tempStone;
                                  _selectedMetal = tempMetal;
                                  _maxPrice = tempPrice;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("APPLY PARAMETERS", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold)),
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
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        itemBuilder: (context, index) {
          bool isSelected = current == options[index];
          return GestureDetector(
            onTap: () => onSelect(options[index]),
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
                  options[index].toUpperCase(),
                  style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 4),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasActiveFilters = _selectedStone != 'All' || _selectedMetal != 'All' || _maxPrice < 5000000;
    final productsAsyncValue = ref.watch(productStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildAmbientGlow(),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLiquidSearchBar(context, hasActiveFilters),

                    Expanded(
                      child: productsAsyncValue.when(
                        data: (products) {
                          final filteredResults = _getFilteredProducts(products);

                          return Column(
                            children: [
                              _buildResultsHeader(filteredResults.length),
                              Expanded(
                                child: filteredResults.isEmpty
                                    ? _buildNoResults()
                                    : _buildResponsiveResultsGrid(filteredResults),
                              ),
                            ],
                          );
                        },
                        loading: () => Center(
                          child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
                        ),
                        error: (error, stack) => Center(
                          child: Text(
                            "CONNECTION LOST",
                            style: TextStyle(color: Colors.redAccent.withValues(alpha: 0.8), fontSize: 10, letterSpacing: 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      bottom: -100,
      left: -50,
      child: Container(
        width: 300, height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.04), blurRadius: 100, spreadRadius: 50)
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 6.seconds),
    );
  }

  Widget _buildLiquidSearchBar(BuildContext context, bool hasActiveFilters) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
          child: Row(
            children: [
              Expanded(
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
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w300),
                        cursorColor: luxuryGold,
                        decoration: InputDecoration(
                          hintText: "SEARCH THE ARCHIVES...",
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 9, letterSpacing: 5, fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.search_rounded, color: luxuryGold.withValues(alpha: 0.6), size: 18),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                  ),
                ).animate().slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuart),
              ),
              const SizedBox(width: 15),

              GestureDetector(
                onTap: () => _showFilterAtelier(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: hasActiveFilters ? luxuryGold.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
                        border: Border.all(color: hasActiveFilters ? luxuryGold : Colors.white.withValues(alpha: 0.08), width: 0.5),
                      ),
                      child: Icon(Icons.tune_rounded, color: hasActiveFilters ? luxuryGold : Colors.white, size: 20),
                    ),
                  ),
                ).animate().slideX(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                  "FOUND TREASURES",
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w300, letterSpacing: 8)
              ),
              Text(
                  "$count PIECES",
                  style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 3)
              ),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms),
      ),
    );
  }

  Widget _buildResponsiveResultsGrid(List<Product> products) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    }

    return AnimationLimiter(
      key: ValueKey('$_selectedStone-$_selectedMetal-$_searchQuery-$_maxPrice'),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 150),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.58,
          crossAxisSpacing: 25,
          mainAxisSpacing: 30,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 800),
            columnCount: crossAxisCount,
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: LuxuryProductCard(
                  product: product,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, color: luxuryGold.withValues(alpha: 0.15), size: 60)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds),
          const SizedBox(height: 30),
          const Text(
            "NO ARTIFACTS MATCH YOUR CRITERIA",
            style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Try broadening your search or adjusting the filters.",
            style: TextStyle(color: Colors.white24, letterSpacing: 1.5, fontSize: 9, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}