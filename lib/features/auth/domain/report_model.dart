class Report {
  final int reportId; // Primary Key
  final String type; // e.g., 'Sales', 'Inventory', 'User Activity'
  final DateTime generatedDate;
  final Map<String, dynamic> data; // The calculated metrics

  Report({
    required this.reportId,
    required this.type,
    required this.generatedDate,
    required this.data,
  });
}