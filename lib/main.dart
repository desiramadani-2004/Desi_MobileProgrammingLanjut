import 'package:flutter/material.dart';
import 'package:utd_advanced_app/core/theme/app_theme.dart';
import 'package:utd_advanced_app/core/routing/app_router.dart';
import 'package:utd_advanced_app/core/di/injection.dart';
import 'package:utd_advanced_app/core/config/env_config.dart'; // 1. IMPORT CONFIG BARU DI SINI! [cite: 324]
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// 1. NAMA TUGAS (Konstanta agar tidak salah ketik)
const String syncTask = "tugas_sinkronisasi_rutin";

// 2. PEKERJA LATAR BELAKANG (Top-Level Function)
// @pragma ini WAJIB agar fungsi tidak terhapus saat aplikasi di-build
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Cek apakah nama tugasnya cocok
    if (taskName == syncTask) {
      try {
        print("Mulai mengambil data dari server secara gaib...");
        // Pura-pura butuh waktu 3 detik untuk download
        await Future.delayed(const Duration(seconds: 3));
        
        // Catat jam berapa tugas berhasil ke memori HP
        final prefs = await SharedPreferences.getInstance();
        String currentTime = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
        await prefs.setString("last_sync_time", "Sinkronisasi diam-diam sukses pada: \n$currentTime");
        
        print("Tugas Latar Belakang Selesai!");
      } catch (e) {
        print("Tugas gagal: $e");
        return Future.value(false); // Lapor gagal
      }
    }
    return Future.value(true); // Lapor sukses ke OS
  });
}

void main() async {
  // WAJIB ditambahkan jika kita menjalankan kode sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi WorkManager (Memberi ID Card ke Satpam)
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Akan memunculkan notifikasi dummy saat uji coba
  );
  // SANGAT PENTING: Panggil Pelayan (GetIt) sebelum aplikasi berjalan!
  setupLocator(); 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ubah dari MaterialApp biasa menjadi MaterialApp.router
    return MaterialApp.router(
      // 2. SEKARANG PITA DEBUG INI BISA DIKONTROL DARI TERMINAL / LAUNCH PROFILE! [cite: 331]
      debugShowCheckedModeBanner: EnvConfig.showDebugBanner,
      title: 'UTD Advanced App',
      theme: AppTheme.lightTheme,
      // Masukkan konfigurasi rute dari app_router.dart
      routerConfig: AppRouter.router, 
    );
  }
}