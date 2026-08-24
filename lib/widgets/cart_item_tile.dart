import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/formatters.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'price_tag.dart';
class CartItemTile extends ConsumerWidget {
  const CartItemTile({super.key, required this.item});
  final CartItem item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  width: 72,
                  height: 72,
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '${formatPrice(product.price)} · max ${product.stock}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => ref
                            .read(cartProvider.notifier)
                            .decrement(product.id),
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${item.quantity}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        onPressed: item.quantity >= product.stock
                            ? null
                            : () => ref
                                .read(cartProvider.notifier)
                                .increment(product.id),
                        icon: const Icon(Icons.add),
                      ),
                      const Spacer(),
                      PriceTag(price: item.lineTotal),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Supprimer',
              onPressed: () {
                ref.read(cartProvider.notifier).remove(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} retiré du panier')),
                );
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}