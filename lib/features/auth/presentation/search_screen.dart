import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/router/app_routes.dart';
import 'widgets/luxury_product_card.dart'; // Using your high-end card

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  String selectedStone = 'All';
  String selectedMetal = 'All';

  final List<String> stones = ['All', 'Emerald', 'Diamond', 'Ruby', 'Sapphire'];
  final List<String> metals = ['All', '22K Gold', '18K Gold', 'Rose Gold', 'Silver'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildArchitecturalSearch(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. MATERIAL CURATION FILTERS
          _buildFilterSection("STONES", stones, (val) => setState(() => selectedStone = val), selectedStone),
          _buildFilterSection("METALS", metals, (val) => setState(() => selectedMetal = val), selectedMetal),

          const Padding(
            padding: EdgeInsets.fromLTRB(25, 40, 25, 15),
            child: Text("FOUND TREASURES",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 6 // Editorial spacing
                )),
          ),

          // 2. DISCOVERY RESULTS
          Expanded(child: _buildResultsGrid()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildArchitecturalSearch(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 80,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
      title: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white10),
          // Sharp edges for the search bar to match the "Acquire" button
          borderRadius: BorderRadius.zero,
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 1),
          cursorColor: luxuryGold,
          decoration: const InputDecoration(
            hintText: "SEARCH THE COLLECTION...",
            hintStyle: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 3),
            prefixIcon: Icon(Icons.search, color: Colors.white24, size: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, Function(String) onSelect, String current) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 12),
          child: Text(title,
              style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 4)),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: options.length,
            itemBuilder: (context, index) {
              bool isSelected = current == options[index];
              return GestureDetector(
                onTap: () => onSelect(options[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: isSelected ? luxuryGold : Colors.transparent,
                    // Sharp architectural edges
                    border: Border.all(color: isSelected ? luxuryGold : Colors.white10),
                  ),
                  child: Center(
                    child: Text(
                      options[index].toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontSize: 9,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w300,
                        letterSpacing: 2,
                      ),
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

  Widget _buildResultsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // Matches the HomePage grid
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        // Using the professional card for consistency
        return LuxuryProductCard(
          title: "Signature Piece",
          price: "\$3,200",
          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail),
        );
      },
    );
  }
}