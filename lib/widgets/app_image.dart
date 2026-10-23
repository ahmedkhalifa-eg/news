import 'package:flutter/material.dart';

/// Image from assets or network with a neutral placeholder on failure.
class AppImage extends StatelessWidget {
  final String? asset;
  final String? url;
  final double? width;
  final double? height;
  final double radius;
  final IconData fallbackIcon;

  const AppImage.asset(
      String this.asset, {
        super.key,
        this.width,
        this.height,
        this.radius = 0,
        this.fallbackIcon = Icons.image_outlined,
      }) : url = null;

  const AppImage.network(
      this.url, {
        super.key,
        this.width,
        this.height,
        this.radius = 0,
        this.fallbackIcon = Icons.image_outlined,
      }) : asset = null;

  Widget _placeholder() => Container(
    width: width,
    height: height,
    color: Colors.grey.shade600.withValues(alpha: 0.35),
    alignment: Alignment.center,
    child: Icon(fallbackIcon, color: Colors.grey.shade500, size: 36),
  );

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (asset != null) {
      child = Image.asset(
        asset!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else if (url == null || url!.isEmpty) {
      child = _placeholder();
    } else {
      child = Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, w, progress) =>
        progress == null ? w : _placeholder(),
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}