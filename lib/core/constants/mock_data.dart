import '../../features/auth/domain/product_model.dart';

/// THE TEMPORARY VAULT
/// This bridge allows existing screens to function while we transition to live Firestore data.
final List<Product> mockProducts = [
  Product(
    id: "p1",
    title: "ROYAL EMERALD RING",
    price: 4500.0,
    description: "Hand-crafted 22K gold featuring a deep-sea Colombian Emerald.",
    category: "RINGS",
    imageUrl: "https://images.unsplash.com/photo-1605100804763-247f67b3f876?q=80&w=2070&auto=format&fit=crop",
    createdAt: DateTime.now(),
    weight: 12.5,
    makingCharges: 250.0,
  ),
  Product(
    id: "p2",
    title: "CELESTIAL DIAMOND NECKLACE",
    price: 12800.0,
    description: "A constellation of VVS1 diamonds set in white gold.",
    category: "NECKLACES",
    imageUrl: "https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?q=80&w=1974&auto=format&fit=crop",
    createdAt: DateTime.now(),
    weight: 45.0,
    makingCharges: 1200.0,
  ),
  Product(
    id: "p3",
    title: "AURUM BRACELET",
    price: 2100.0,
    description: "Solid 24K gold links with a brushed matte finish.",
    category: "BRACELETS",
    imageUrl: "https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=2070&auto=format&fit=crop",
    createdAt: DateTime.now(),
    weight: 22.0,
    makingCharges: 150.0,
  ),
];