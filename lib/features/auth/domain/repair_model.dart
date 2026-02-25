class RepairOrder {
  final int repairId; // Primary Key
  final String customerName; // Linked to User Table
  final String itemDescription; // Jewelry details
  final String issue; // e.g., 'Broken Clasp', 'Stone Polishing'
  final String status; // 'Pending', 'In Repair', 'Ready'
  final double estimatedCost;

  RepairOrder({
    required this.repairId,
    required this.customerName,
    required this.itemDescription,
    required this.issue,
    required this.status,
    required this.estimatedCost,
  });
}