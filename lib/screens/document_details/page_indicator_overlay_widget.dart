import 'package:flutter/material.dart';

class PageIndicatorOverlay extends StatelessWidget {
  final int currentIndex;
  final int total;
  final Color backgroundColor;
  final Color textColor;

  const PageIndicatorOverlay({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${currentIndex + 1}/$total',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
