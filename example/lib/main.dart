import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info/wifi_info.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _wifiName = 'Unknown';
  final _wifiInfoPlugin = WifiInfo();

  @override
  void initState() {
    super.initState();
    _loadWifiInfo();
  }

  Future<void> _loadWifiInfo() async {
    try {
      final info = await _wifiInfoPlugin.getWifiInfo();
      if (mounted) {
        setState(() => _wifiName = info?.ssid ?? 'Unknown');
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
