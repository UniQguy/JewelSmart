import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/product_model.dart';

/// THE MASTER LEDGER (INVENTORY)
/// Manages real-time global stock levels and atomic inventory transactions for the 2026 Collection.
class InventoryNotifier extends StateNotifier<Map<int, int>> {
  InventoryNotifier() : super({
    // Initializing the Vault: Default limited edition stock of 12 for all physical pieces
    for (var p in mockProducts) p.productId: 12,
  });

  // Procedure: Secure additional stock (Stock In)
  void stockIn(int productId, int amount) {
    state = {
      ...state,
      productId: (state[productId] ?? 0) + amount,
    };
  }

  // Procedure: Fulfill acquisition (Stock Out)
  // Ensures stock cannot drop below zero during high-demand secure transitions.
  void stockOut(int productId, int amount) {
    final currentStock = state[productId] ?? 0;
    if (currentStock >= amount) {
      state = {
        ...state,
        productId: currentStock - amount,
      };
    }
  }

  // Procedure: Availability Check
  // Used by the UI to prevent users from adding out-of-stock items to their Vault.
  bool isAvailable(int productId, {int requestedAmount = 1}) {
    return (state[productId] ?? 0) >= requestedAmount;
  }
}

/// INVENTORY STATE PROVIDER
/// Injects the Master Ledger globally, allowing cart validations and acquisition finalizations.
final inventoryProvider = StateNotifierProvider<InventoryNotifier, Map<int, int>>((ref) {
  return InventoryNotifier();
});