import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';

/// Preloads an asset image before showing it on screen.
/// Displays a loader while the image is being prepared.

class PreloadedImage extends StatefulWidget {
  final String path;
  final double? width;
  final double? loaderHeight;
  final BoxFit fit;

  const PreloadedImage({
    super.key,
    required this.path,
    this.width,
    this.loaderHeight,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!loaded) {
      return SizedBox(
        width: widget.width,
        height: widget.loaderHeight,
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.loadingIndicatorSecondary,
          ),
        ),
      );
    }

    return Image.asset(widget.path, width: widget.width, fit: widget.fit);
  }
}
