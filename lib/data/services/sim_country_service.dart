import 'package:flutter/services.dart';

class SimCountry {
  static const _channel = MethodChannel('sim_country');

  static Future<String?> getCountry() async {
    try {
      final result = await _channel.invokeMethod<String>('getSimCountry');
      return result;
    } catch (e) {
      return null;
    }
  }
}
