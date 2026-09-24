import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedProductImage extends StatelessWidget {
  const CachedProductImage({
    super.key,
    required this.imageUrl,
    this.cacheWidth,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final int? cacheWidth;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: cacheWidth,
      placeholder: (context, url) => const ColoredBox(
        color: Color(0x11000000),
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      errorWidget: (context, url, error) => Semantics(
        label: 'Image indisponible',
        image: true,
        child: const ColoredBox(
          color: Color(0x11000000),
          child: Center(child: Icon(Icons.image_not_supported_outlined)),
        ),
      ),
    );
  }
}
