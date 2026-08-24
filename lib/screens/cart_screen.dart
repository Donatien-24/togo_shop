import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_strings.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/price_tag.dart';
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    const shipping = 0.0;
    final total = subtotal + shipping;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cartTitle),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: AppStrings.clearCart,
              onPressed: () => _confirmClear(context, ref),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text(AppStrings.emptyCart))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return CartItemTile(item: items[index]);
                    },
                  ),
                ),
                _CartSummary(subtotal: subtotal, total: total),
              ],
            ),
    );
  }
  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.clearCart),
          content: const Text(
            'Tous les articles seront retirés. Continuer ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Vider'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      ref.read(cartProvider.notifier).clear();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Panier vidé')),
      );
    }
  }
}
class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.subtotal, required this.total});
  final double subtotal;
  final double total;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(AppStrings.subtotal),
                  const Spacer(),
                  PriceTag(price: subtotal),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    AppStrings.total,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  PriceTag(price: total, large: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}