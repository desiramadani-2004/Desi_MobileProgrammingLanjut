import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // 1. Definisikan Pipa Komunikasi (MethodChannel)
  // Nama ini HARUS SAMA PERSIS dengan yang ada di MainActivity.kt
  static const platform = MethodChannel('utd_advanced_app/native');

  String _batteryLevel = 'Baterai belum dicek.';

  // 2. Fungsi untuk menyeberang ke Android dan meminta sisa baterai
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      // Memanggil fungsi 'getBatteryLevel' di Kotlin
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Sisa Baterai: $result %';
    } on PlatformException catch (e) {
      batteryLevel = "Gagal membaca sistem Android: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  // 3. Fungsi untuk menyeberang ke Android dan mengirim pesan teks
  Future<void> _showNativeToast() async {
    try {
      // Memanggil fungsi 'showToast' di Kotlin dan mengirimkan data 'pesan'
      // TUGAS: Ubah isi pesan di bawah ini dengan "Nama - NIM" kamu untuk laporan
      await platform.invokeMethod('showToast', {
        "pesan": "Halo, ini pesan dari Dunia Dart!"
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memunculkan toast: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrasi Native OS'),
        // Tombol Back untuk kembali ke Katalog
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(); // Kembali jika ada halaman sebelumnya
            } else {
              context.go('/'); // Paksa kembali ke root (Katalog) jika tidak ada history
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.battery_charging_full, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              _batteryLevel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _getBatteryLevel,
              icon: const Icon(Icons.refresh),
              label: const Text('Cek Baterai (Native)'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _showNativeToast,
              icon: const Icon(Icons.notifications_active),
              label: const Text('Munculkan Native Toast'),
            ),
          ],
        ),
      ),
    );
  }
}