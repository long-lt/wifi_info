import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info_ext/wifi_info.dart';
import 'package:wifi_info_ext/wifi_info.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _wifiName = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadWifiInfo();
  }

  Future<void> _loadWifiInfo() async {
    try {
      final wifiName = await WifiInfo.instance.networkName();
      if (mounted) {
        setState(() => _wifiName = wifiName ?? 'Unknown');
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(
            () => _wifiName = e.message ?? 'Failed to get info');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Wi‑Fi Info')),
        body: Center(
          child: Text('$_wifiName', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
