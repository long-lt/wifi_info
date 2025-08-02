import 'package:flutter/services.dart';
import 'wifi_info_platform_interface.dart';

class MethodChannelWifiInfo extends WifiInfoPlatform {
  final methodChannel = const MethodChannel('wifi_info');

  @override
  Future<Map<String, String>?> getWifiInfo() async {
    final result = await methodChannel.invokeMethod<Map>('getWifiInfo');
    return result?.cast<String, String>();
  }
}
