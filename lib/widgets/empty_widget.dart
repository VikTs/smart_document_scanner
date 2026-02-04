import 'package:flutter/material.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 300),
            SizedBox(height: 16),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: 4),
              Text(
                message!,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 16),
            footer ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
