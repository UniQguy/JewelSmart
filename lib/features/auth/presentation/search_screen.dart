import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/router/app_routes.dart';
import '../domain/product_model.dart';
import 'widgets/luxury_product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _searchController = TextEditingController();

  String _selectedStone = 'All';
  String _selectedMetal = 'All';
  String _searchQuery = '';
  // Procedure Sync: Added dynamic price threshold
  double _maxPrice = 1000000.0;

  final List<String> stones = ['All', 'Emerald', 'Diamond', 'Ruby', 'Sapphire'];
  final List<String> metals = ['All', '22K', '18K', 'Silver'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // LOGIC: Filter products based on Data Dictionary and Price Calculation
  List<Product> _getFilteredProducts() {
    return mockProducts.where((product) {
      final matchesStone = _selectedStone == 'All' || product.stone.toUpperCase() == _selectedStone.toUpperCase();
      final matchesMetal = _selectedMetal == 'All' || product.purity.toUpperCase() == _selectedMetal.toUpperCase();
      final matchesSearch = product.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // Calculation Sync: Logic matches Billing Controller (Base + Making)
      final double totalPrice = product.basePrice + product.makingCharges;
      final matchesPrice = totalPrice <= _maxPrice;

      return matchesStone && matchesMetal && matchesSearch && matchesPrice;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _getFilteredProducts();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildAmbientGlow(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLiquidSearchBar(context),
                _buildFilterSection("STONES", stones, (val) => setState(() => _selectedStone = val), _selectedStone),
                _buildFilterSection("PURITY", metals, (val) => setState(() => _selectedMetal = val), _selectedMetal),

                // NEW: Price Threshold Slider Section
                _buildSectionLabel("PRICE THRESHOLD"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: luxuryGold,
                      inactiveTrackColor: Colors.white10,
                      thumbColor: luxuryGold,
                      valueIndicatorColor: luxuryGold,
                      valueIndicatorTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    child: Slider(
                      value: _maxPrice,
                      min: 10000,
                      max: 1000000,
                      divisions: 20,
                      label: "UNDER \$${_maxPrice.toInt()}",
                      onChanged: (val) => setState(() => _maxPrice = val),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("FOUND TREASURES",
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300, letterSpacing: 8)),
                      Text("${filteredResults.length} PIECES",
                          style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                ),

                Expanded(
                    child: filteredResults.isEmpty
                        ? _buildNoResults()
                        : _buildResultsGrid(filteredResults)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 25, 30, 12),
      child: Text(title, style: const TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 4)),
    );
  }

  // Rest of the UI helper methods (AmbientGlow, SearchBar, FilterSection, ResultsGrid, NoResults) remain unchanged

  Widget _buildAmbientGlow() {
    return Positioned(
      bottom: -100,
      left: -50,
      child: Container(
        width: 300, height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withOpacity(0.02),
          boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.05), blurRadius: 100, spreadRadius: 50)],
        ),
      ),
    );
  }

  Widget _buildLiquidSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2),
                    cursorColor: luxuryGold,
                    decoration: InputDecoration(
                      hintText: "SEARCH THE COLLECTION...",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.15), fontSize: 10, letterSpacing: 5),
                      prefixIcon: Icon(Icons.search_rounded, color: luxuryGold.withOpacity(0.4), size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, Function(String) onSelect, String current) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(title),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            physics: const BouncingScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              bool isSelected = current == options[index];
              return GestureDetector(
                onTap: () => onSelect(options[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: isSelected ? luxuryGold : Colors.white.withOpacity(0.02),
                    border: Border.all(color: isSelected ? luxuryGold : Colors.white10),
                  ),
                  child: Center(
                    child: Text(options[index].toUpperCase(),
                      style: TextStyle(color: isSelected ? Colors.black : Colors.white60, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 3),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultsGrid(List<Product> products) {
    return AnimationLimiter(
      key: ValueKey('$_selectedStone-$_selectedMetal-$_searchQuery-$_maxPrice'),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.58, crossAxisSpacing: 25, mainAxisSpacing: 30,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 800),
            columnCount: 2,
            child: FadeInAnimation(
              child: LuxuryProductCard(
                product: product,
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product),
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
          Icon(Icons.diamond_outlined, color: luxuryGold.withOpacity(0.1), size: 50),
          const SizedBox(height: 20),
          Text("THE COLLECTION IS STILL EVOLVING",
            style: TextStyle(color: luxuryGold.withOpacity(0.3), letterSpacing: 8, fontSize: 10),
          ),
        ],
      ),
    );
  }
}