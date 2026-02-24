class Product {
  final String id;
  final String title;
  final String price;
  final String category;
  final String imagePath;
  final String description;
  final String metal;
  final String stone;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.description,
    this.metal = "22K GOLD",
    this.stone = "EMERALD",
  });
}

final List<Product> mockProducts = [
  Product(
    id: '1',
    title: "EMERALD LEGACY",
    price: "\$4,500",
    category: "NECKLACES",
    imagePath: 'assets/images/login_bg.jpg',
    description: "A masterpiece of timeless elegance. Hand-selected deep-sea emeralds encased in a 22K brushed gold frame.",
  ),
  Product(
    id: '2',
    title: "CELESTIAL RING",
    price: "\$2,200",
    category: "RINGS",
    imagePath: 'assets/images/login_bg.jpg',
    description: "Inspired by the stars, this diamond-encrusted ring features a central sapphire of unparalleled clarity.",
  ),
  Product(
    id: '3',
    title: "AURORA BRACELET",
    price: "\$3,800",
    category: "BRACELETS",
    imagePath: 'assets/images/login_bg.jpg',
    description: "A liquid-gold flow that wraps around the wrist, featuring intermittent ruby accents.",
  ),
];