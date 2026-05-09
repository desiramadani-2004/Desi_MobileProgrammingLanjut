package com.example.utd_advanced_app

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // 1. Nama Pipa (Channel) HARUS SAMA PERSIS dengan yang ada di Dart
    private val CHANNEL = "utd_advanced_app/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 2. Mendengarkan panggilan dari Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            
            // JIKA FLUTTER MEMINTA BATERAI:
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel) // Kirim angka baterai ke Flutter
                } else {
                    result.error("UNAVAILABLE", "Sistem Android gagal membaca baterai.", null)
                }
            } 
            // JIKA FLUTTER MEMINTA MUNCULKAN TOAST:
            else if (call.method == "showToast") {
                // Tangkap data 'pesan' yang dikirim dari Flutter
                val pesan = call.argument<String>("pesan")
                
                // Munculkan Toast asli milik Android
                Toast.makeText(this, pesan, Toast.LENGTH_SHORT).show()
                result.success(null)
            } 
            // JIKA PERINTAH TIDAK DIKENALI
            else {
                result.notImplemented()
            }
        }
    }

    // Fungsi bawaan Android untuk membaca sensor Baterai Hardware
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }
}