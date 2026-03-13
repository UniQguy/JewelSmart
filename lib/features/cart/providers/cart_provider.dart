import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/product_model.dart';

/// THE CART ITEM ENTITY
/// A secure wrapper to handle quantity management for each unique SKU in the vault.
class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Helper to update quantity while keeping the core product data immutable
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// THE VAULT MANAGER (StateNotifier)
/// Handles the acquisition ledger, precision quantity adjustments, and final clearances.
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Procedure: Add item to vault. If it exists, increment the quantity.
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

  // Procedure: Precision decrement. Removes the item entirely if quantity drops below 1.
  void decrementQuantity(int productId) {
    final existingIndex = state.indexWhere((item) => item.product.productId == productId);

    if (existingIndex != -1) {
      if (state[existingIndex].quantity > 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == existingIndex)
              state[i].copyWith(quantity: state[i].quantity - 1)
            else
              state[i],
        ];
      } else {
        // Automatically remove the item if the user decrements past 1
        removeItem(productId);
      }
    }
  }

  // Procedure: Remove specific SKU completely from the vault
  void removeItem(int productId) {
    state = state.where((item) => item.product.productId != productId).toList();
  }

  // Procedure: paymentSuccess -> updateStock() -> Clear Vault
  void clearCart() {
    state = [];
  }
}

// 1. MAIN VAULT PROVIDER: StateNotifierProvider allows complex ledger logic
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// 2. COMPUTED COUNT PROVIDER: Sums all individual item quantities for the MainWrapper dock badge
final cartCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});

// 3. PRICE PROVIDER: Automates the "Calculate Price" business logic
// Multiplies the total payable amount (Base + Making + GST) by the quantity for each item
final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + (item.product.totalPayableAmount * item.quantity));
});