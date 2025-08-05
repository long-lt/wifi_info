package com.tah.wifi_info

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.location.LocationManager
import android.net.wifi.WifiManager
import android.net.wifi.WifiInfo
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class WifiInfoPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private var activity: Activity? = null
  private val LOCATION_REQUEST_CODE = 12345

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "wifi_info")
    channel.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() { activity = null }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { activity = binding.activity }
  override fun onDetachedFromActivity() { activity = null }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "getWifiInfo" -> {
        checkAndGetWifiInfo(result)
      }
      else -> result.notImplemented()
    }
  }

  private fun checkAndGetWifiInfo(result: MethodChannel.Result) {
    // 1. Kiểm tra quyền Location
    if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
      ActivityCompat.requestPermissions(activity!!, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), LOCATION_REQUEST_CODE)
      result.error("NO_LOCATION_PERMISSION", "Ứng dụng chưa được cấp quyền truy cập vị trí", null)
      return
    }

    // 2. Kiểm tra GPS đang bật
    val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) &&
      !locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
      result.error("GPS_OFF", "GPS chưa được bật", null)
      return
    }

    // 3. Lấy SSID & BSSID
    val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
    val info: WifiInfo = wifiManager.connectionInfo

    @SuppressLint("MissingPermission")
    val ssid = info.ssid?.replace("\"", "")
    val bssid = info.bssid

    if (ssid == "<unknown ssid>" || bssid == "02:00:00:00:00:00") {
      result.error("UNAVAILABLE", "Không thể lấy SSID/BSSID. Hãy kiểm tra quyền và trạng thái kết nối WiFi.", null)
      return
    }

    result.success(mapOf("ssid" to ssid, "bssid" to bssid))
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
