import 'wifi_info_platform_interface.dart';

class WifiInfo {
  // Singleton instance
  static final WifiInfo _instance = WifiInfo._internal();
  factory WifiInfo() => _instance;
  static WifiInfo get instance => _instance;
  WifiInfo._internal();

  /// Lấy BSSID
  Future<String?> bssid() async {
    final jsonInfo = await WifiInfoPlatform.instance.getWifiInfo();
    final bssid = jsonInfo['bssid'];
    return bssid;
  }

  /// Lấy tên mạng Wi-Fi (SSID)
  Future<String?> networkName() async {
    final jsonInfo = await WifiInfoPlatform.instance.getWifiInfo();
    final name = jsonInfo['ssid'];
    return name;
  }
}
