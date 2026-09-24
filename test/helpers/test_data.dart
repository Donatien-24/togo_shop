import 'package:togoshop/models/product.dart';

Product sampleProduct({
  String id = 'product-1',
  String name = 'Panier artisanal',
  double price = 2500,
  String category = 'Artisanat',
  double rating = 4.5,
  int stock = 3,
}) {
  return Product(
    id: id,
    name: name,
    description: 'Produit de test',
    price: price,
    imageUrl: 'https://example.com/$id.jpg',
    category: category,
    rating: rating,
    stock: stock,
  );
}
