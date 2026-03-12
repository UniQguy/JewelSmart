import '../../domain/repositories/purchase_repository.dart';
import '../../domain/purchase_model.dart';

class MockPurchaseRepository implements PurchaseRepository {
  @override
  Future<List<PurchaseRecord>> getPurchaseHistory() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    return [
      PurchaseRecord(
          orderId: "JS-99281",
          purchaseDate: DateTime(2026, 2, 10),
          productName: "Ethereal Emerald Ring",
          amountPaid: 45000.00,
          status: "SECURED"
      ),
      PurchaseRecord(
          orderId: "JS-99285",
          purchaseDate: DateTime(2026, 3, 05),
          productName: "Golden Infinity Band",
          amountPaid: 12000.00,
          status: "SHIPPED"
      ),
    ];
  }
}