import 'package:flutter_riverpod/flutter_riverpod.dart';

// Holds the image URL of the product the user wants to try on
final activeTryOnImageProvider = StateProvider<String?>((ref) => null);