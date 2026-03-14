import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/product_model.dart';

/// THE CURATION ENGINE (WISHLIST STATE)
/// Manages the user's private collection of desired assets globally.
class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]);

  // Procedure: Add or Remove from Vault
  void toggleWishlist(Product product) {
    if (state.any((p) => p.id == product.id)) {
      // If it exists, remove it
      state = state.where((p) => p.id != product.id).toList();
    } else {
      // If it doesn't exist, secure it to the wishlist
      state = [...state, product];
    }
  }

  // Procedure: Validation Check
  bool isInWishlist(String productId) {
    return state.any((p) => p.id == productId);
  }
}

/// WISHLIST STATE PROVIDER
final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<Product>>((ref) {
  return WishlistNotifier();
});