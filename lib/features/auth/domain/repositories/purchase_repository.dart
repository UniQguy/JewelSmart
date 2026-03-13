import '../purchase_model.dart';

abstract class PurchaseRepository {
  // FIXED: Changed Purchase to PurchaseRecord and added the userId parameter
  Future<List<PurchaseRecord>> getPurchaseHistory(String userId);
}