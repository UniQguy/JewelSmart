import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jewelry_model.dart';

final catalogProvider = Provider<List<JewelryItem>>((ref) {
  return [
    JewelryItem(
      id: '1',
      name: 'Eternal Gold Necklace',
      category: 'Necklace',
      price: 1250.00,
      imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f', // Real sample image
      description: 'A 24k gold necklace with intricate filigree work.',
      isArEnabled: true,
    ),
    JewelryItem(
      id: '2',
      name: 'Diamond Stud Earrings',
      category: 'Earrings',
      price: 850.00,
      imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908',
      description: 'Classic diamond studs set in white gold.',
      isArEnabled: true,
    ),
  ];
});