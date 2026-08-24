import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_card.dart';
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFavorites = ref.watch(favoriteProductsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favoritesTitle)),
      body: asyncFavorites.when(
        loading: () => const LoadingWidget(),
        error: (error, _) => AppErrorWidget(
          message: 'Impossible de charger les favoris.\n$error',
          onRetry: () => ref.invalidate(productsProvider),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text(AppStrings.emptyFavorites));
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: catalogCrossAxisCount(width),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: catalogChildAspectRatio(width),
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}