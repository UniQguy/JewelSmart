import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateProvider is perfect for simple states like a list or a counter
final cartProvider = StateProvider<List<String>>((ref) {
  return []; // Initial empty cart
});

// A computed provider to get just the item count
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});