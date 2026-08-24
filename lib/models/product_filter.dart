enum ProductSort { none, priceAsc, priceDesc, rating }
class ProductFilter {
  const ProductFilter({
    this.category = 'Tous',
    this.query = '',
    this.sort = ProductSort.none,
  });
  final String category;
  final String query;
  final ProductSort sort;
  ProductFilter copyWith({
    String? category,
    String? query,
    ProductSort? sort,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      query: query ?? this.query,
      sort: sort ?? this.sort,
    );
  }
}