import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import const syncTask dari main.dart. Pastikan path titik-titiknya benar.
import 'package:utd_advanced_app/main.dart';

class BackgroundSyncPage extends StatefulWidget {
  const BackgroundSyncPage({super.key});

  @override
  State<BackgroundSyncPage> createState() => _BackgroundSyncPageState();
}

class _BackgroundSyncPageState extends State<BackgroundSyncPage> {
  String _lastSyncInfo = "Belum pernah sinkronisasi";

  @override
  void initState() {
    super.initState();
    _cekWaktuSyncTerakhir();
  }

  // Fungsi untuk membaca hardisk HP (SharedPreferences)
  Future<void> _cekWaktuSyncTerakhir() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSyncInfo = prefs.getString("last_sync_time") ?? "Belum pernah sinkronisasi";
    });
  }

  // Fungsi untuk Mendaftar Tugas Rutin (Mandat ke OS)
  void _mulaiSinkronisasiRutin() {
    Workmanager().registerPeriodicTask(
      "unique_id_sync_01", // ID unik tugas ini
      syncTask, // Nama tugas yang diambil dari main.dart
      frequency: const Duration(minutes: 15), // Minimal 15 Menit (Aturan Android)
      constraints: Constraints(
        networkType: NetworkType.connected, // Hanya jalan jika ada internet
        requiresBatteryNotLow: true, // Jangan jalan jika baterai lemah (merah)
        requiresCharging: true, // <-- TUGAS MANDIRI 2: WAJIB DI-CAS
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Auto-Sync Aktif! (Hanya jalan saat HP di-cas)")),
    );
  }

  // Fungsi untuk Membatalkan Tugas
  void _hentikanSinkronisasi() {
    Workmanager().cancelByUniqueName("unique_id_sync_01");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Auto-Sync Dibatalkan!")),
    );
  }

  // --- TUGAS MANDIRI 1: TUGAS SEKALI JALAN (ONE-OFF TASK) ---
  void _mulaiTugasSekaliJalan() {
    Workmanager().registerOneOffTask(
      "unique_id_oneoff_01", // ID Unik untuk task ini
      syncTask, // Memanggil fungsi yang sama di main.dart
      initialDelay: const Duration(seconds: 10), // Tunggu 10 detik baru jalan
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tugas 1x Jalan Aktif! (Tutup app & tunggu 10 detik)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Background')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_sync, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 20),
              const Text("Terakhir Dikerjakan Oleh Latar Belakang:",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              // Menampilkan waktu dari SharedPreferences
              Text(
                _lastSyncInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: _mulaiSinkronisasiRutin,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Auto-Sync'), // Label diperpendek agar muat
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    onPressed: _hentikanSinkronisasi,
                    icon: const Icon(Icons.stop),
                    label: const Text('Matikan'),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Jarak antar tombol
              
              // --- TOMBOL TUGAS MANDIRI 1 ---
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], foregroundColor: Colors.white),
                onPressed: _mulaiTugasSekaliJalan,
                icon: const Icon(Icons.timer),
                label: const Text('Tugas 1x Jalan (10 Detik)'),
              ),
              // ------------------------------
              
              const SizedBox(height: 20),
              // Tombol untuk memuat ulang UI membaca data terbaru
              TextButton.icon(
                onPressed: _cekWaktuSyncTerakhir,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Tampilan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}