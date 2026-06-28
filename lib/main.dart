import 'package:flutter/material.dart';
import 'package:utd_advanced_app/core/theme/app_theme.dart';
import 'package:utd_advanced_app/core/routing/app_router.dart';
import 'package:utd_advanced_app/core/di/injection.dart';
import 'package:utd_advanced_app/core/config/env_config.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// 🔥 IMPORT HALAMAN LOGIN BARU DI SINI UNTUK INTEGRATION TEST [cite: 379]
import 'package:utd_advanced_app/features/auth/presentation/pages/login_screen.dart';

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
    // 🛠️ MODIFIKASI SEMENTARA UNTUK INTEGRATION TEST [cite: 401]
    // Kita ubah MaterialApp.router menjadi MaterialApp biasa agar robot langsung tertuju ke LoginScreen [cite: 350, 401]
    return MaterialApp(
      debugShowCheckedModeBanner: EnvConfig.showDebugBanner,
      title: 'UTD Advanced App',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), // Robot akan langsung mendarat di halaman ini! [cite: 401]
      
      // Catatan: routerConfig sengaja dimatikan sementara agar tidak bentrok dengan 'home:'
      // routerConfig: AppRouter.router, 
    );
  }
}