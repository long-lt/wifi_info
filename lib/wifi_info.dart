import 'wifi_info_platform_interface.dart';

class WifiInfo {
  static Future<Map<String, String>?> getWifiInfo() {
    return WifiInfoPlatform.instance.getWifiInfo();
  }
}
