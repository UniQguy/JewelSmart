import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/invoice_model.dart';

class InvoiceService {
  /// Mints the database record AND generates the physical PDF document bytes
  static Future<Uint8List> generateInvoiceDocument({
    required String orderId,
    required String userId,
    required String artifactName,
    required double baseTotal,
  }) async {
    // 1. Calculate Indian Jewelry Tax (3% GST)
    final double gstAmount = baseTotal * 0.03;
    final double finalAmount = baseTotal + gstAmount;

    // 2. Log it to the Firestore Vault
    final docRef = FirebaseFirestore.instance.collection('invoices').doc();
    final invoice = Invoice(
      invoiceId: docRef.id,
      orderId: orderId,
      userId: userId,
      date: DateTime.now(),
      amount: finalAmount,
    );
    await docRef.set(invoice.toMap());

    // 3. Generate the Physical PDF Document (Luxury Minimalist Design)
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("MAISON JEWELSMART", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, letterSpacing: 4)),
                      pw.SizedBox(height: 5),
                      pw.Text("THE APEX OF FINE CRAFTSMANSHIP", style: const pw.TextStyle(fontSize: 8, letterSpacing: 2, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.normal, color: PdfColors.grey400, letterSpacing: 4)),
                ],
              ),
              pw.SizedBox(height: 50),

              // Meta Data
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildPdfMetaBlock("INVOICE ID", docRef.id.toUpperCase()),
                  _buildPdfMetaBlock("DATE MINTED", "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                  _buildPdfMetaBlock("CLIENT ID", userId.substring(0, 8).toUpperCase()),
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Divider(color: PdfColors.grey300, thickness: 0.5),
              pw.SizedBox(height: 30),

              // Artifact Details
              pw.Text("SECURED ARTIFACT", style: const pw.TextStyle(fontSize: 8, letterSpacing: 2, color: PdfColors.grey600)),
              pw.SizedBox(height: 10),
              pw.Text(artifactName.toUpperCase(), style: pw.TextStyle(fontSize: 16, letterSpacing: 2, fontWeight: pw.FontWeight.bold)),
              pw.Text("HASH REF: ${orderId.toUpperCase()}", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),

              pw.SizedBox(height: 50),
              pw.Divider(color: PdfColors.grey300, thickness: 0.5),
              pw.SizedBox(height: 30),

              // Financial Breakdown
              _buildPdfPriceRow("BASE VALUATION", "INR ${baseTotal.toStringAsFixed(2)}"),
              pw.SizedBox(height: 10),
              _buildPdfPriceRow("GOVERNMENT TAX (GST 3%)", "INR ${gstAmount.toStringAsFixed(2)}"),
              pw.SizedBox(height: 20),

              // Total
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                color: PdfColors.grey100,
                child: _buildPdfPriceRow("FINAL SETTLEMENT", "INR ${finalAmount.toStringAsFixed(2)}", isBold: true),
              ),

              pw.Spacer(),

              // Footer
              pw.Center(
                child: pw.Text("THIS IS A CRYPTOGRAPHICALLY GENERATED FINANCIAL RECORD.", style: const pw.TextStyle(fontSize: 7, letterSpacing: 2, color: PdfColors.grey500)),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildPdfMetaBlock(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 8, letterSpacing: 2, color: PdfColors.grey600)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildPdfPriceRow(String label, String value, {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: isBold ? 12 : 10, letterSpacing: 1, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value, style: pw.TextStyle(fontSize: isBold ? 12 : 10, letterSpacing: 1, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    );
  }
}