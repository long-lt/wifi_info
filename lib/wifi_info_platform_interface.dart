import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'wifi_info_method_channel.dart';

abstract class WifiInfoPlatform extends PlatformInterface {
  WifiInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static WifiInfoPlatform _instance = MethodChannelWifiInfo();

  static WifiInfoPlatform get instance => _instance;

  static set instance(WifiInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<String, String>?> getWifiInfo() {
    throw UnimplementedError('getWifiInfo() has not been implemented.');
  }
}
