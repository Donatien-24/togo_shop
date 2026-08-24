import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_filter.dart';
/// Filtre (catégorie, recherche) et tri du catalogue.
final filterProvider = StateProvider<ProductFilter>((ref) {
  return const ProductFilter();
});