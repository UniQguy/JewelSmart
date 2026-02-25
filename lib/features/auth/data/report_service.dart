import '../domain/report_model.dart';
import '../domain/product_model.dart';

class ReportService {
  // Logic Sync: Fulfills the 'generateReport()' method in Class Diagram
  static Report generateSalesReport(List<Product> products) {
    double totalValue = 0;

    // Procedure: Aggregate data from the Jewelry_Product Table
    for (var product in products) {
      totalValue += product.basePrice + product.makingCharges;
    }

    return Report(
      reportId: DateTime.now().millisecondsSinceEpoch,
      type: 'SALES SUMMARY',
      generatedDate: DateTime.now(),
      data: {
        'total_sku_count': products.length,
        'inventory_valuation': totalValue,
        'tax_estimate': totalValue * 0.03, // 3% GST calculation
      },
    );
  }
}