import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/product_model.dart'; // REQUIRED for Data Dictionary sync

// 1. NEW DATA MODEL: Wrapper to handle quantity for each SKU
// This allows item.product and item.quantity calls in success_page.dart
class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Helper to update quantity while keeping product data immutable
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

// 2. UPDATED NOTIFIER: Manages the 'Add Items to Cart' Use Case
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Procedure: Add item. If exists, increment quantity; if not, add new CartItem.
  void addItem(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.productId == product.productId);

    if (existingIndex != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  // Procedure: Remove specific SKU from the vault
  void removeItem(int productId) {
    state = state.where((item) => item.product.productId != productId).toList();
  }

  // Procedure: paymentSuccess -> updateStock() -> Clear Cart
  void clearCart() {
    state = [];
  }
}

// 3. UPDATED PROVIDER: StateNotifierProvider allows complex logic like clearCart()
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// 4. COMPUTED COUNT PROVIDER: Sums all individual quantities in the vault
final cartCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});

// 5. PRICE PROVIDER: Automates the "Calculate Price" procedure
// Multiplies the total payable amount by the quantity for each item
final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + (item.product.totalPayableAmount * item.quantity));
});