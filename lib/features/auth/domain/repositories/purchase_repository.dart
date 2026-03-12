import '../purchase_model.dart';

abstract class PurchaseRepository {
  Future<List<PurchaseRecord>> getPurchaseHistory();
}