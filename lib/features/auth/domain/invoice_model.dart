class Invoice {
  final int invoiceId; // Primary Key
  final int userId; // Foreign Key to Customer
  final DateTime date;
  final double amount; // Final total including GST

  Invoice({
    required this.invoiceId,
    required this.userId,
    required this.date,
    required this.amount,
  });
}