import 'package:flutter/services.dart';

class ShareService {
  static const _channel = MethodChannel('shared_image');

  static Future<String?> getSharedImage() async {
    final path = await _channel.invokeMethod<String>(
      'getSharedImage',
    );

    return path;
  }
}