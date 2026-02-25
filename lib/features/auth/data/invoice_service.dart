import '../domain/invoice_model.dart';
import '../domain/product_model.dart';

class InvoiceService {
  // Procedure Sync: Fulfills generateInvoice() in Class Diagram
  static Invoice generateInvoice(Product product, int userId) {
    // Calculates total using the Billing Controller logic
    final double total = product.basePrice + product.makingCharges;
    final double totalWithGst = total + (total * 0.03); // 3% GST

    return Invoice(
      invoiceId: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      date: DateTime.now(),
      amount: totalWithGst,
    );
  }
}