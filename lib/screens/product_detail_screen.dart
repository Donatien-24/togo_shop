import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/formatters.dart';
import '../core/utils/responsive.dart';

import '../models/product.dart';

import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';

import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/price_tag.dart';
import '../widgets/cached_product_image.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(selectedProductProvider);

    return asyncProduct.when(
      loading: () => const Scaffold(
        body: LoadingWidget(message: 'Chargement du produit…'),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget(message: 'Produit introuvable.\n$error'),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppErrorWidget(message: 'Aucun produit sélectionné.'),
          );
        }

        return _ProductDetailBody(product: product);
      },
    );
  }
}

class _ProductDetailBody extends ConsumerWidget {
  const _ProductDetailBody({required this.product});
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(product.id);
    final tablet = isTabletLayout(context);
    final image = Hero(
      tag: 'product-image-${product.id}',
      child: AspectRatio(
        aspectRatio: tablet ? 1 : 16 / 11,
        child: CachedProductImage(
          imageUrl: product.imageUrl,
          cacheWidth: tablet ? 900 : 720,
        ),
      ),
    );
    final info = _ProductInfo(
      product: product,
      isFavorite: isFavorite,
      onToggleFavorite: () async {
        await ref.read(favoritesProvider.notifier).toggle(product.id);
        if (!context.mounted) return;
        final nowFavorite = ref.read(favoritesProvider).contains(product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              nowFavorite
                  ? '${product.name} ajouté aux favoris'
                  : '${product.name} retiré des favoris',
            ),
          ),
        );
      },
      onAddToCart: () {
        if (!product.isInStock) return;
        ref.read(cartProvider.notifier).add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} ajouté au panier')),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: tablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: image),
                Expanded(child: SingleChildScrollView(child: info)),
              ],
            )
          : ListView(children: [image, info]),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });
  final Product product;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToCart;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            product.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(product.category)),
              Chip(
                avatar: const Icon(Icons.star_rounded, size: 18),
                label: Text(formatRating(product.rating)),
              ),
              Chip(
                avatar: const Icon(Icons.inventory_2_outlined, size: 18),
                label: Text('${AppStrings.stock} : ${product.stock}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PriceTag(price: product.price, large: true),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: product.isInStock ? onAddToCart : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(
              product.isInStock ? AppStrings.addToCart : 'Rupture de stock',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onToggleFavorite,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(
              isFavorite
                  ? AppStrings.removeFromFavorites
                  : AppStrings.addToFavorites,
            ),
          ),
        ],
      ),
    );
  }
}
