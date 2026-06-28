import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// Memanggil pintu masuk utama aplikasi kamu
import 'package:utd_advanced_app/main.dart' as app;

void main() {
  // Ini wajib dipanggil untuk menghubungkan kode test ke HP / Emulator fisik kamu
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End: Alur Login Admin Sukses', (WidgetTester tester) async {
    // 1. ARRANGE (Nyalakan Aplikasi)
    app.main(); // Menjalankan fungsi main() asli aplikasi kita seperti biasa
    
    // Tunggu sampai aplikasi selesai loading awal / splash screen
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 2. ACT (Mulai Mengetik & Mengklik Otomatis)
    // Robot mencari kotak Email berdasarkan key lalu mengetik teks
    final fieldEmail = find.byKey(const Key('field_email'));
    await tester.enterText(fieldEmail, 'admin@utd.id');

    // Robot mencari kotak Password berdasarkan key lalu mengetik teks
    final fieldPassword = find.byKey(const Key('field_password'));
    await tester.enterText(fieldPassword, 'rahasia123');

    // Perintahkan Robot untuk menutup keyboard HP agar tombol login tidak tertutup
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Robot menekan tombol Login!
    final tombolLogin = find.byKey(const Key('tombol_login'));
    await tester.tap(tombolLogin);

    // Tunggu beberapa detik sampai animasi perpindahan halaman selesai
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 3. ASSERT (Pembuktian)
    // Buktikan bahwa layar berhasil pindah dan memunculkan teks selamat datang
    expect(find.text('Selamat Datang Admin!'), findsOneWidget);
    
    // Buktikan bahwa tombol login sudah hilang dari layar (karena sudah pindah halaman)
    expect(find.text('LOGIN SEKARANG'), findsNothing);
  });
}