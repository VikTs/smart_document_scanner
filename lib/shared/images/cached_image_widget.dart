import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Displays an in-memory image from bytes.
/// If the same bytes are passed again, the previous image
/// is reused to avoid unnecessary rebuilds.

class CachedImage extends StatefulWidget {
  final Uint8List bytes;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CachedImage({
    super.key,
    required this.bytes,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  late ImageProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = MemoryImage(widget.bytes);
  }

  @override
  void didUpdateWidget(covariant CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bytes != widget.bytes) {
      _provider = MemoryImage(widget.bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: _provider,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      gaplessPlayback: true,
    );
  }
}