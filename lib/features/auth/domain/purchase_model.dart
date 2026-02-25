class PurchaseRecord {
  final String orderId; // PK from Order Table
  final DateTime purchaseDate;
  final String productName; // FK to Jewelry_Product
  final double amountPaid; // From Payment Table
  final String status; // e.g., 'Secured', 'In Transit', 'Delivered'

  PurchaseRecord({
    required this.orderId,
    required this.purchaseDate,
    required this.productName,
    required this.amountPaid,
    required this.status,
  });
}