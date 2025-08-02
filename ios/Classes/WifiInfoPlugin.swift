import Flutter
import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork

public class WifiInfoPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var pendingResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wifi_info", binaryMessenger: registrar.messenger())
        let instance = WifiInfoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getWifiInfo":
            self.pendingResult = result
            requestLocationPermissionIfNeeded()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func requestLocationPermissionIfNeeded() {
        let status = CLLocationManager.authorizationStatus()

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            sendWifiInfo()
        } else if status == .notDetermined {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        } else {
            pendingResult?(FlutterError(code: "NO_LOCATION_PERMISSION",
                                        message: "Location permission not granted",
                                        details: nil))
            pendingResult = nil
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            sendWifiInfo()
        } else if status != .notDetermined {
            pendingResult?(FlutterError(code: "NO_LOCATION_PERMISSION",
                                        message: "Location permission denied",
                                        details: nil))
            pendingResult = nil
        }
    }

    private func sendWifiInfo() {
        guard let ssid = getSSID(), let bssid = getBSSID() else {
            pendingResult?(FlutterError(code: "NO_WIFI_INFO",
                                        message: "Unable to retrieve Wi-Fi info",
                                        details: nil))
            pendingResult = nil
            return
        }
        pendingResult?(["ssid": ssid, "bssid": bssid])
        pendingResult = nil
    }

    private func getSSID() -> String? {
        guard let interface = (CNCopySupportedInterfaces() as? [String])?.first,
              let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any],
              let ssid = unsafeInterfaceData["SSID"] as? String else {
            return nil
        }
        return ssid
    }

    private func getBSSID() -> String? {
        guard let interface = (CNCopySupportedInterfaces() as? [String])?.first,
              let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any],
              let bssid = unsafeInterfaceData["BSSID"] as? String else {
            return nil
        }
        return bssid
    }
}
