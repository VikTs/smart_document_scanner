import 'package:flutter/services.dart';

class ShortcutService {
  static const _quickScanChannel = MethodChannel('quick_scan');

  static Future<bool> shouldStartQuickScan() async {
    final result = await _quickScanChannel.invokeMethod<bool>(
      'shouldStartQuickScan',
    );

    return result ?? false;
  }
}