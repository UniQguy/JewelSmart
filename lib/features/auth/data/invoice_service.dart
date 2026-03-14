import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/invoice_model.dart';

class InvoiceService {
  // Procedure Sync: Fulfills generateInvoice() in Class Diagram
  // UPGRADED: Now an async function that pushes directly to the live Firestore matrix
  static Future<Invoice> generateInvoice(String orderId, String userId, double baseTotal) async {

    // Calculates total using the Indian Jewelry Tax logic (3% GST)
    final double gstAmount = baseTotal * 0.03;
    final double finalAmount = baseTotal + gstAmount;

    // Generate Document Reference to get a unique String ID
    final docRef = FirebaseFirestore.instance.collection('invoices').doc();

    final invoice = Invoice(
      invoiceId: docRef.id,
      orderId: orderId,
      userId: userId,
      date: DateTime.now(),
      amount: finalAmount,
    );

    // Push to the Live Vault
    await docRef.set(invoice.toMap());

    return invoice;
  }
}