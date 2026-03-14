import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/product_model.dart';

/// THE LIVE DATA PIPELINE
/// Continuously streams real-world product data from the Firebase Firestore 'products' collection.
final productStreamProvider = StreamProvider<List<Product>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true) // Shows the newest collections first
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  });
});