import Flutter
import UIKit
import CoreLocation
import NetworkExtension

public class WifiInfoPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var result: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wifi_info", binaryMessenger: registrar.messenger())
        let instance = WifiInfoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getWifiInfo":
            self.result = result
            requestWifiInfo()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func requestWifiInfo() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            fetchWifiInfo()
        } else {
            result?(FlutterError(code: "PERMISSION_DENIED", message: "Quyền Location bị từ chối", details: nil))
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            fetchWifiInfo()
        } else if status != .notDetermined {
            result?(FlutterError(code: "PERMISSION_DENIED", message: "Quyền Location bị từ chối", details: nil))
        }
    }

    private func fetchWifiInfo() {
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { [weak self] network in
                DispatchQueue.main.async {
                    if let network = network {
                        self?.result?([
                            "ssid": network.ssid,
                            "bssid": network.bssid
                        ])
                    } else {
                        self?.result?(FlutterError(code: "NO_WIFI", message: "Không lấy được Wi‑Fi info", details: nil))
                    }
                }
            }
        } else {
            result?(FlutterError(code: "UNSUPPORTED", message: "Yêu cầu iOS 14 trở lên", details: nil))
        }
    }
}
