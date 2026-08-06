import 'dart:io';
import 'package:flutter/material.dart';

class FileImageWithPlaceholder extends StatelessWidget {
  final File? file;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget placeholder;
  final Widget? errorPlaceholder;

  const FileImageWithPlaceholder({
    super.key,
    required this.file,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    required this.placeholder,
    this.errorPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return placeholder;
    }

    return Image.file(
      file!,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, _) {
        if (frame == null) {
          return placeholder;
        }

        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return errorPlaceholder ?? placeholder;
      },
    );
  }
}
