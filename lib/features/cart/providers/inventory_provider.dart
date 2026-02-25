import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/product_model.dart';

// StateNotifier to manage the Inventory Table data
class InventoryNotifier extends StateNotifier<Map<int, int>> {
  InventoryNotifier() : super({
    for (var p in mockProducts) p.productId: 12, // Default stock of 12 for all
  });

  // Procedure: Stock In
  void stockIn(int productId, int amount) {
    state = {
      ...state,
      productId: (state[productId] ?? 0) + amount,
    };
  }

  // Procedure: Stock Out
  void stockOut(int productId, int amount) {
    if ((state[productId] ?? 0) >= amount) {
      state = {
        ...state,
        productId: state[productId]! - amount,
      };
    }
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, Map<int, int>>((ref) {
  return InventoryNotifier();
});