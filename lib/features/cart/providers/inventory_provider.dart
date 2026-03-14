import 'package:flutter_riverpod/flutter_riverpod.dart';

/// THE MASTER LEDGER (INVENTORY)
/// Manages real-time global stock levels and atomic inventory transactions for the 2026 Collection.
class InventoryNotifier extends StateNotifier<Map<String, int>> {
  // FIXED: Start with an empty secure vault instead of hardcoding mock data
  InventoryNotifier() : super({});

  // Helper method: Assume a default limited edition stock of 12 for all live pieces unless explicitly tracked
  int _getCurrentStock(String productId) => state[productId] ?? 12;

  // Procedure: Secure additional stock (Stock In)
  void stockIn(String productId, int amount) {
    state = {
      ...state,
      productId: _getCurrentStock(productId) + amount,
    };
  }

  // Procedure: Fulfill acquisition (Stock Out)
  void stockOut(String productId, int amount) {
    final currentStock = _getCurrentStock(productId);
    if (currentStock >= amount) {
      state = {
        ...state,
        productId: currentStock - amount,
      };
    }
  }

  // Procedure: Availability Check
  bool isAvailable(String productId, {int requestedAmount = 1}) {
    return _getCurrentStock(productId) >= requestedAmount;
  }
}

/// INVENTORY STATE PROVIDER
final inventoryProvider = StateNotifierProvider<InventoryNotifier, Map<String, int>>((ref) {
  return InventoryNotifier();
});