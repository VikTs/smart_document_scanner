import 'package:flutter/material.dart';

/// Preloads an asset image before showing it on screen.
/// Displays a loader while the image is being prepared.

class PreloadedImage extends StatefulWidget {
  final String path;
  final double? width;
  final BoxFit fit;

  const PreloadedImage({
    super.key,
    required this.path,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  State<PreloadedImage> createState() => _PreloadedImageState();
}

class _PreloadedImageState extends State<PreloadedImage> {
  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(AssetImage(widget.path), context).then((_) {
      if (mounted) {
        setState(() => loaded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return SizedBox(
        width: widget.width,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Image.asset(
      widget.path,
      width: widget.width,
      fit: widget.fit,
    );
  }
}