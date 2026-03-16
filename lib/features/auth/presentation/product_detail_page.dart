import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../cart/providers/cart_provider.dart';
import '../domain/product_model.dart';
import '../../wishlist/providers/wishlist_provider.dart';
import '../../try_on/providers/active_try_on_provider.dart';

/// THE EDITORIAL PRODUCT VIEW
/// Engineered for 3D spatial depth, immersive parallax, real-time reviews, and INR currency.
/// SECURED: Includes Role-Based Access Control and Purchase Validation.
class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final ScrollController _scrollController = ScrollController();

  double _scrollOffset = 0.0;
  String? _productId;

  // Security & Clearance States
  bool _isAdmin = false;
  bool _hasPurchased = false;
  bool _isCheckingAccess = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Grab the product ID and run security clearance once when the page loads
    if (_productId == null) {
      final product = ModalRoute.of(context)!.settings.arguments as Product;
      _productId = product.id;
      _verifyUserClearance(product.id);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- SECURITY CLEARANCE ENGINE ---
  Future<void> _verifyUserClearance(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isCheckingAccess = false);
      return;
    }

    try {
      // 1. Verify Role
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final role = userDoc.data()?['role'] ?? 'customer';
      bool isAdmin = (role == 'admin' || role == 'staff');

      // 2. Verify Purchase History
      bool hasPurchased = false;
      if (!isAdmin) {
        final orderQuery = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .get();

        for (var doc in orderQuery.docs) {
          final data = doc.data();
          final items = data['items'] as List<dynamic>? ?? [];
          // Checks if the product exists in any of their past orders
          if (items.any((item) => item['id'] == productId || item['productId'] == productId)) {
            hasPurchased = true;
            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          _isAdmin = isAdmin;
          _hasPurchased = hasPurchased;
          _isCheckingAccess = false;
        });
      }
    } catch (e) {
      debugPrint("Clearance check failed: $e");
      if (mounted) setState(() => _isCheckingAccess = false);
    }
  }

  // --- THE REVIEW ATELIER (BOTTOM SHEET) ---
  void _showReviewAtelier(BuildContext context, String productId) {
    int selectedRating = 5;
    final TextEditingController reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600), // Web Scaler
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Container(width: 40, height: 2, color: Colors.white24)),
                            const SizedBox(height: 30),
                            Text("SEAL YOUR IMPRESSION", style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 6, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 40),

                            // Interactive Star Rating
                            const Text("EVALUATION", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 6)),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setSheetState(() => selectedRating = index + 1);
                                  },
                                  child: Icon(
                                    index < selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                                    color: index < selectedRating ? luxuryGold : Colors.white24,
                                    size: 40,
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 40),

                            // Review Text Input
                            const Text("YOUR LEGACY COMMENT", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 6)),
                            const SizedBox(height: 10),
                            TextField(
                              controller: reviewController,
                              maxLines: 3,
                              style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.5, fontWeight: FontWeight.w300),
                              cursorColor: luxuryGold,
                              decoration: InputDecoration(
                                hintText: "Describe the craftsmanship...",
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.02),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: luxuryGold, width: 0.5),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  backgroundColor: luxuryGold.withValues(alpha: 0.1),
                                ),
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  await _submitReview(productId, selectedRating, reviewController.text);
                                  if (context.mounted) Navigator.pop(context);
                                },
                                child: const Text("IMMORTALIZE IMPRESSION", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold)),
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
          ),
        );
      },
    );
  }

  Future<void> _submitReview(String productId, int rating, String comment) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Fetch user's actual name
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userName = userDoc.exists ? (userDoc.data()?['name'] ?? 'VIP CLIENT') : 'VIP CLIENT';

      // Push to Subcollection
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .add({
        'userId': user.uid,
        'userName': userName,
        'rating': rating,
        'comment': comment.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Failed to submit review: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildAmbientBackdrop(),

          // MAIN SCROLL CONTENT
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800), // Editorial Column width
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  _buildParallaxHeader(context, product),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBrandHeader(),
                          const SizedBox(height: 10),
                          _buildEditorialTitle(product),
                          const SizedBox(height: 40),
                          _buildPriceSection(product),
                          const SizedBox(height: 40),
                          _buildDescriptionSection(product),
                          const SizedBox(height: 50),
                          _buildBoutiqueSpecifications(product),
                          const SizedBox(height: 60),

                          // The Live Review Engine
                          _buildReviewsSection(product.id),

                          const SizedBox(height: 150), // Buffer for the acquisition bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FLOATING ACTIONS
          _buildBackAction(context),
          _buildWishlistAction(product),
          _buildVirtualAtelierAction(context, product), // FIXED: Passed product to the action
          _buildBottomAcquisitionBar(context, ref, product),
        ],
      ),
    );
  }

  Widget _buildAmbientBackdrop() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.5),
            radius: 1.2,
            colors: [luxuryGold.withValues(alpha: 0.08), Colors.black],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxHeader(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'product_image_${product.id}',
              child: _buildNetworkImage(product),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent, Colors.black],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(Product product) {
    if (product.imageUrl.isEmpty) {
      return Container(color: Colors.black, child: Center(child: Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.2), size: 40)));
    }
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      alignment: Alignment(0, (_scrollOffset * 0.001).clamp(-1.0, 1.0)),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.black,
          child: Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: luxuryGold.withValues(alpha: 0.5), strokeWidth: 1.5))),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 800.ms);
      },
      errorBuilder: (context, error, stackTrace) => Container(color: Colors.black, child: Center(child: Icon(Icons.broken_image_outlined, color: Colors.white.withValues(alpha: 0.1), size: 40))),
    );
  }

  Widget _buildBrandHeader() {
    return const Text("PRIVATE COLLECTION • 2026", style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 5, fontWeight: FontWeight.w900)).animate().fadeIn(duration: 800.ms, delay: 200.ms);
  }

  Widget _buildEditorialTitle(Product product) {
    return Text(product.title.toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 34, fontWeight: FontWeight.w100, letterSpacing: 2, height: 1.1)).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildPriceSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "₹${product.totalPayableAmount.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w300, letterSpacing: 2),
        ),
        const SizedBox(height: 4),
        const Text("INCLUDES 3% GST & HANDCRAFTING CHARGES", style: TextStyle(color: Colors.white24, fontSize: 7, letterSpacing: 2, fontWeight: FontWeight.bold)),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms);
  }

  Widget _buildDescriptionSection(Product product) {
    return Text(
      product.description.isNotEmpty ? product.description : "A masterpiece of artisanal precision, this piece represents the pinnacle of the 2026 legacy collection.",
      style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.8, letterSpacing: 0.5, fontWeight: FontWeight.w300),
    ).animate().fadeIn(duration: 800.ms, delay: 500.ms);
  }

  Widget _buildBoutiqueSpecifications(Product product) {
    return Column(
      children: [
        _specRow("PURITY", "${product.purity}K FINE GOLD"),
        _divider(),
        _specRow("WEIGHT", "${product.weight}G"),
        _divider(),
        _specRow("MAKING", "₹${product.makingCharges}"),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _buildReviewsSection(String productId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("CLIENT IMPRESSIONS", style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 5, fontWeight: FontWeight.w900)),

            if (_isCheckingAccess)
              SizedBox(width: 10, height: 10, child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1))
            else if (_hasPurchased)
              GestureDetector(
                onTap: () => _showReviewAtelier(context, productId),
                child: Text("LEAVE IMPRESSION", style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
              )
            else if (!_isAdmin)
                const Text("ACQUIRE TO IMPRESS", style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 20),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').doc(productId).collection('reviews').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("BE THE FIRST TO SEAL AN IMPRESSION OF THIS ARTIFACT.", style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10, fontStyle: FontStyle.italic)),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final name = data['userName'] ?? 'VIP CLIENT';
                final comment = data['comment'] ?? '';
                final rating = data['rating'] ?? 5;

                return _buildReviewCard(name, comment, rating);
              },
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 700.ms);
  }

  Widget _buildReviewCard(String name, String comment, int rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 3, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: index < rating ? luxuryGold : Colors.white24,
                  size: 12,
                )),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(comment, style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.5, fontWeight: FontWeight.w300)),
          ]
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.white.withValues(alpha: 0.05), height: 1);
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomAcquisitionBar(BuildContext context, WidgetRef ref, Product product) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (_isAdmin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("REDIRECTING TO INVENTORY...", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 2)), backgroundColor: Colors.black),
                      );
                    } else {
                      ref.read(cartProvider.notifier).addItem(product);
                      _showSuccessNotification(context);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: luxuryGold.withValues(alpha: 0.8), width: 0.5),
                      boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.1), blurRadius: 30, spreadRadius: -10)],
                    ),
                    child: Center(
                      child: Text(
                          _isAdmin ? "MANAGE ARTIFACT" : "ACQUIRE PIECE",
                          style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, letterSpacing: 8, fontSize: 9)
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0.0, duration: 800.ms, curve: Curves.easeOutExpo);
  }

  void _showSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        duration: const Duration(seconds: 3),
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: luxuryGold, size: 18),
                      const SizedBox(width: 15),
                      const Text("PIECE SECURED IN VAULT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 8)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackAction(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.maybePop(context);
            },
            style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.2), padding: const EdgeInsets.all(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistAction(Product product) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 20,
      child: Consumer(
          builder: (context, ref, child) {
            final isSaved = ref.watch(wishlistProvider.notifier).isInWishlist(product.id);

            return ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: IconButton(
                  icon: Icon(
                      isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isSaved ? luxuryGold : Colors.white,
                      size: 16
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(wishlistProvider.notifier).toggleWishlist(product);
                    setState(() {});
                  },
                  style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.2), padding: const EdgeInsets.all(12)),
                ),
              ),
            );
          }
      ),
    );
  }

  // --- THE VIRTUAL ATELIER ENTRY POINT ---
  // FIXED: Added product parameter to accurately update the provider
  Widget _buildVirtualAtelierAction(BuildContext context, Product product) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70, // Placed directly below the Wishlist button
      right: 20,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Consumer( // Wrap the button in a Consumer
              builder: (context, ref, child) {
                return IconButton(
                  icon: Icon(Icons.view_in_ar_outlined, color: luxuryGold, size: 18),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    // 1. SET THE IMAGE URL IN RIVERPOD SECURELY
                    ref.read(activeTryOnImageProvider.notifier).state = product.imageUrl;

                    // 2. NAVIGATE TO THE ATELIER
                    Navigator.pushNamed(context, '/try-on');
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: luxuryGold.withValues(alpha: 0.1),
                      side: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                      padding: const EdgeInsets.all(12)
                  ),
                );
              }
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms).scale(curve: Curves.easeOutBack);
  }
}