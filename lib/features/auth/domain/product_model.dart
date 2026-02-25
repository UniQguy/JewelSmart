class Product {
  final int productId; // Primary key
  final String title;  // Jewelry name [cite: 7]
  final String category; // Gold/Silver/Diamond [cite: 7]
  final String purity;   // 22K/18K [cite: 7]
  final double weight;   // Weight in grams
  final double basePrice; // Base price
  final double makingCharges; // Making charges
  final String imagePath; // Product image [cite: 7, 105]
  final String description;
  final String stone;
  final String status; // Available/Sold [cite: 7]

  Product({
    required this.productId,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.basePrice,
    required this.makingCharges,
    required this.weight,
    this.purity = "22K",
    this.stone = "EMERALD",
    this.status = "Available",
  });

  // Business Logic: Matches the Activity Diagram procedures [cite: 121, 122, 128]
  // Calculates Price -> Applies GST -> Displays Final Amount
  double get totalPayableAmount {
    double subtotal = basePrice + makingCharges;
    double gstAmount = subtotal * 0.03; // Standard 3% GST for jewelry [cite: 122]
    return subtotal + gstAmount;
  }

  // Formatted string for UI display
  String get formattedPrice => "\$${totalPayableAmount.toStringAsFixed(2)}";
}

final List<Product> mockProducts = [
  Product(
    productId: 1, // [cite: 7]
    title: "EMERALD LEGACY",
    category: "NECKLACES", // [cite: 7]
    imagePath: 'assets/images/login_bg.jpg',
    description: "A masterpiece of timeless elegance. Hand-selected deep-sea emeralds encased in a 22K brushed gold frame.",
    basePrice: 4200.0, // [cite: 7]
    makingCharges: 300.0, // [cite: 7]
    weight: 14.2, //
    purity: "22K", // [cite: 7]
  ),
  Product(
    productId: 2,
    title: "CELESTIAL RING",
    category: "RINGS",
    imagePath: 'assets/images/login_bg.jpg',
    description: "Inspired by the stars, this diamond-encrusted ring features a central sapphire of unparalleled clarity.",
    basePrice: 2000.0,
    makingCharges: 200.0,
    weight: 5.5,
    purity: "18K",
  ),
];