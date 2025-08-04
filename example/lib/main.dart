import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wifi_info_plus/wifi_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Map<String, String>? wifiInfo;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion = 'Unknown';
    Map<String, String>? info;

    try {
      info = await WifiInfo.getWifiInfo();
      platformVersion = 'iOS Wi-Fi Info';
    } on PlatformException catch (e) {
      platformVersion = 'Failed to get Wi-Fi info: ${e.message}';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      wifiInfo = info;
    });
  }


  @override
  Widget build(BuildContext context) {
    final ssid = wifiInfo?['ssid'] ?? '-';
    final bssid = wifiInfo?['bssid'] ?? '-';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WiFi Info Plugin Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Status: $_platformVersion\n'),
              Text('SSID: $ssid'),
              Text('BSSID: $bssid'),
            ],
          ),
        ),
      ),
    );
  }
}
