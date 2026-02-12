class JewelryItem {
  final String id;
  final String name;
  final String category; // e.g., Necklace, Ring, Earrings
  final double price;
  final String imageUrl;
  final String description;
  final bool isArEnabled;

  JewelryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.isArEnabled = false,
  });
}