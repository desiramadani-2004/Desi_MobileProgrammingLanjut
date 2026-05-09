import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk menggunakan fungsi compute()


int tugasMenghitungBerat(int jumlahLooping) {
  int hasil = 0;
  for (int i = 0; i < jumlahLooping; i++) {
    hasil += i;
  }
  return hasil;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;
  
  // Variabel untuk Tugas Mandiri 2 (State Management Perubahan Harga)
  double _previousPrice = 0.0;
  Color _priceColor = Colors.green;

  @override
  void initState() {
    super.initState();
    // Hubungkan telepon ke Server CoinCap saat halaman dibuka
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );
  }

  @override
  void dispose() {
    // WAJIB! Tutup telepon saat halaman ditinggalkan agar memori tidak bocor
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Harga Bitcoin'),
        backgroundColor: Colors.orange.shade800,
      ),
      body: StreamBuilder(
        stream: _channel.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Koneksi Terputus!'));
          }

          // Ambil datanya
          final String dataString = snapshot.data as String;
          final Map<String, dynamic> dataJson = jsonDecode(dataString);
          final String currentPriceString = dataJson['bitcoin'] ?? '0.00';
          
          // --- LOGIKA TUGAS MANDIRI 2 (Cek Harga Naik/Turun) ---
          final double currentPriceDouble = double.tryParse(currentPriceString) ?? 0.0;
          if (currentPriceDouble > _previousPrice) {
            _priceColor = Colors.green; // Naik = Hijau
          } else if (currentPriceDouble < _previousPrice) {
            _priceColor = Colors.red; // Turun = Merah
          }
          // Simpan harga saat ini sebagai harga lama untuk pengecekan selanjutnya
          _previousPrice = currentPriceDouble;
          // -----------------------------------------------------

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),
                const SizedBox(height: 20),
                const Text('Harga BTC/USD Saat Ini:', style: TextStyle(fontSize: 18)),
                Text(
                  '\$$currentPriceString',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _priceColor, // Warna berubah otomatis dari logika di atas
                  ),
                ),
                const SizedBox(height: 40),
                
                // Indikator ini harusnya berputar lancar 60 FPS
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                
                // --- TOMBOL SIKSA MAIN THREAD (STEP 4) ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    print("Mulai menghitung di Main Thread...");
                    int hasil = 0;
                    for (int i = 0; i < 4000000000; i++) {
                      hasil += i;
                    }
                    print("Selesai! Hasilnya: $hasil");
                  },
                  child: const Text('Siksa Main Thread (Layar akan Macet!)', style: TextStyle(color: Colors.white)),
                ),
                
                const SizedBox(height: 10),
                
                // --- TOMBOL ISOLATE (STEP 5) ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    print("Mulai menghitung di Isolate...");
                    // Gunakan Pekerja Gudang (Isolate)
                    int hasil = await compute(tugasMenghitungBerat, 4000000000);
                    print("Selesai dari Isolate! Hasilnya: $hasil");
                  },
                  child: const Text('Gunakan Isolate (Layar Tetap Lancar)', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}