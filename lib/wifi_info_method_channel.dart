import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'wifi_info_platform_interface.dart';

/// An implementation of [WifiInfoPlatform] that uses method channels.
class MethodChannelWifiInfo extends WifiInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wifi_info');

  @override
  Future<Map<String, String?>> getWifiInfo() async {
    final info = await methodChannel.invokeMethod<Map>('getWifiInfo');
    return {
      'ssid': info?['ssid'] as String?,
      'bssid': info?['bssid'] as String?,
    };
  }
}
