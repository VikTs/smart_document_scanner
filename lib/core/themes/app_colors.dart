import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  Color get loadingIndicator => Colors.white;
  Color get textLight => Colors.white;

  Color get iconPrimary => primary;
  Color get iconSecondary => Colors.white;
  Color get iconDisabled => const Color(0xFF6B7280);

  Color get messagePrimaryBackground => Colors.blue;
  Color get messageSecondaryBackground => const Color(0xFFEEEEEE);
  Color get onMessagePrimary => Colors.white;
  Color get onMessageSecondary => const Color(0xDD000000);

  Color get overlaySoft => const Color(0x42000000);
  Color get overlayStrong => const Color(0x8A000000);

  Color get ocrBorder => Colors.blue;
  Color get cameraBackground => Colors.black;
  Color get galleryPlaceholder => Colors.grey;

  Color get snackbarWarning => const Color(0xFFFF9800);
  Color get snackbarError => const Color(0xFFF44336);
  Color get snackbarSuccess => const Color(0xFF47bb64);

  Color get settingsSurface => Colors.grey;
  Color get settingsTextStrong => const Color(0xFF616161);
}
