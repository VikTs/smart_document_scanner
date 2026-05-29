import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InfoBannerOverlay extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final double fontSize;
  final EdgeInsets padding;

  const InfoBannerOverlay({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
