import 'dart:typed_data';
import 'package:flutter/material.dart';

class CachedImage extends StatefulWidget {
  final Uint8List bytes;

  const CachedImage({
    super.key,
    required this.bytes,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  ImageProvider? _provider;

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
    return Image(image: _provider!, gaplessPlayback: true);
  }
}