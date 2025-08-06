# wifi_info

A Flutter plugin to retrieve Wi-Fi network information such as SSID, BSSID, and IP address on Android and iOS.

## Features

- Get connected Wi-Fi SSID
- Get connected Wi-Fi BSSID
- Get local IP address
- Support for Android and iOS
- Null safety

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅         | Requires `ACCESS_FINE_LOCATION` or `ACCESS_WIFI_STATE` permissions |
| iOS      | ✅         | Requires location usage description in `Info.plist` |

## Installation

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  wifi_info: ^1.0.0
```

## Usage

```
import 'package:wifi_info/wifi_info.dart';

void getWifiData() async {
  final ssid = await WifiInfo.ssid;
  final bssid = await WifiInfo.bssid;
  final ip = await WifiInfo.ipAddress;

  print('SSID: $ssid');
  print('BSSID: $bssid');
  print('IP Address: $ip');
}
```

##  Android Setup
Add the following permissions in android/app/src/main/AndroidManifest.xml:

```
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```
## iOS Setup
Add the following to your ios/Runner/Info.plist:

```
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to get Wi-Fi information.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location to get Wi-Fi information.</string>

```
