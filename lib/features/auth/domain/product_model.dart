import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final int stock;
  final DateTime createdAt;

  final double purity;
  final double weight;
  final double makingCharges;

  // NEW: Gemstone Identifier
  final String primaryStone;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.stock = 1,
    required this.createdAt,
    this.purity = 22.0,
    this.weight = 0.0,
    this.makingCharges = 0.0,
    this.primaryStone = '', // Added
  });

  String get productId => id;
  String get imagePath => imageUrl;
  double get totalPayableAmount => price + makingCharges;
  String get formattedPrice => "₹${price.toStringAsFixed(2)}";

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'stock': stock,
      'createdAt': Timestamp.fromDate(createdAt),
      'purity': purity,
      'weight': weight,
      'makingCharges': makingCharges,
      'primaryStone': primaryStone, // Added
    };
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? 'UNKNOWN ARTIFACT',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      category: data['category'] ?? 'UNCATEGORIZED',
      imageUrl: data['imageUrl'] ?? '',
      stock: data['stock'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      purity: (data['purity'] ?? 22.0).toDouble(),
      weight: (data['weight'] ?? 0.0).toDouble(),
      makingCharges: (data['makingCharges'] ?? 0.0).toDouble(),
      primaryStone: data['primaryStone'] ?? '', // Added
    );
  }
}