import 'package:flutter/material.dart';
import '../core/utils/formatters.dart';
class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price, this.large = false});
  final double price;
  final bool large;
  @override
  Widget build(BuildContext context) {
    final style = large
        ? Theme.of(context).textTheme.headlineSmall
        : Theme.of(context).textTheme.titleMedium;
    return Text(
      formatPrice(price),
      style: style?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}