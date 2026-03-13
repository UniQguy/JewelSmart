import 'purchase_repository.dart';
import '../purchase_model.dart';

/// THE SECURE ARCHIVE SIMULATOR
/// An implementation of PurchaseRepository designed to simulate
/// network latency and return high-end mock acquisition data.
class MockPurchaseRepository implements PurchaseRepository {

  @override
  Future<List<PurchaseRecord>> getPurchaseHistory(String userId) async {
    // Simulate a complex decryption and secure network retrieval
    await Future.delayed(const Duration(milliseconds: 1500));

    // Returning high-fidelity mock data aligned with our 2026 Private Collection
    return [
      PurchaseRecord(
          orderId: "JS-99281",
          purchaseDate: DateTime(2026, 2, 10),
          productName: "EMERALD LEGACY",
          amountPaid: 4635.00, // $4200 base + $300 making + 3% GST
          status: "SECURED IN VAULT"
      ),
      PurchaseRecord(
          orderId: "JS-99285",
          purchaseDate: DateTime(2026, 3, 05),
          productName: "IMPERIAL BAND",
          amountPaid: 7210.00, // $6500 base + $500 making + 3% GST
          status: "PRIVATE COURIER DISPATCHED"
      ),
      PurchaseRecord(
          orderId: "JS-99302",
          purchaseDate: DateTime(2026, 3, 11),
          productName: "CELESTIAL SAPPHIRE",
          amountPaid: 2266.00, // $2000 base + $200 making + 3% GST
          status: "AUTHENTICATED"
      ),
    ];
  }
}