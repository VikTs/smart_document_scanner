import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/shared/images/preloaded_image_widget.dart';

class EmptyWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? message;
  final Widget? footer;

  const EmptyWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.message,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: PreloadedImage(
                  path: imagePath,
                  width: 300,
                  loaderHeight: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 4),
                Text(
                  message!,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              footer ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
