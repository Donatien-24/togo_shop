import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/product_filter.dart';
import '../providers/filter_provider.dart';
import '../providers/products_provider.dart';
import 'error_widget.dart';
import 'loading_widget.dart';
import 'product_card.dart';
class CatalogToolbar extends ConsumerWidget {
  const CatalogToolbar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            onChanged: (value) {
              ref.read(filterProvider.notifier).state =
                  filter.copyWith(query: value);
            },
            decoration: const InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final category in AppConstants.categories)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: filter.category == category,
                    onSelected: (_) {
                      ref.read(filterProvider.notifier).state =
                          filter.copyWith(category: category);
                    },
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Wrap(
            spacing: 8,
            children: [
              _SortChip(
                label: 'Prix ↑',
                selected: filter.sort == ProductSort.priceAsc,
                onSelected: () => _setSort(ref, ProductSort.priceAsc),
              ),
              _SortChip(
                label: 'Prix ↓',
                selected: filter.sort == ProductSort.priceDesc,
                onSelected: () => _setSort(ref, ProductSort.priceDesc),
              ),
              _SortChip(
                label: 'Note',
                selected: filter.sort == ProductSort.rating,
                onSelected: () => _setSort(ref, ProductSort.rating),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void _setSort(WidgetRef ref, ProductSort sort) {
    final current = ref.read(filterProvider);
    ref.read(filterProvider.notifier).state = current.copyWith(
      sort: current.sort == sort ? ProductSort.none : sort,
    );
  }
}
class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
class CatalogGrid extends ConsumerWidget {
  const CatalogGrid({super.key, required this.padding});
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(filteredProductsProvider);
    return asyncProducts.when(
      loading: () => const LoadingWidget(message: 'Chargement du catalogue…'),
      error: (error, _) => AppErrorWidget(
        message: 'Impossible de charger les produits.\n$error',
        onRetry: () => ref.invalidate(productsProvider),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text(AppStrings.emptyCatalog));
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GridView.builder(
              padding: padding,
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
    );
  }
}