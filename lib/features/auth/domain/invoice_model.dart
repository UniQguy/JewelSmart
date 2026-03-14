class Invoice {
  final String invoiceId; // Upgraded to String for Firestore compatibility
  final String orderId;   // NEW: Links the invoice to a specific purchase
  final String userId;    // Upgraded to String for Firebase Auth UID
  final DateTime date;
  final double amount;    // Final total including 3% GST

  Invoice({
    required this.invoiceId,
    required this.orderId,
    required this.userId,
    required this.date,
    required this.amount,
  });

  // Converts the blueprint into a format Firestore can read
  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'orderId': orderId,
      'userId': userId,
      'date': date,
      'amount': amount,
    };
  }
}