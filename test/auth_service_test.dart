import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Sesuaikan path ini dengan namamu jika merah
import 'package:utd_advanced_app/features/auth/api_client.dart';
import 'package:utd_advanced_app/features/auth/auth_service.dart';

// 1. MEMBUAT STUNTMAN: Kita ciptakan kloningan ApiClient
class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('Pengujian AuthService dengan Mocktail -', () {
    late MockApiClient stuntman;
    late AuthService authService;

    setUp(() {
      stuntman = MockApiClient();
      // Kita suntikkan si STUNTMAN ke dalam AuthService, BUKAN internet asli!
      authService = AuthService(stuntman);
    });

    test('Login sukses: Stuntman pura-pura berhasil nembak API', () async {
      // 1. ARRANGE: Ajari Stuntman cara berakting
      // "Hei Stuntman, kalau emailnya admin@utd.com, langsung jawab TRUE ya, gak usah mikir!"
      when(() => stuntman.login('admin@utd.com', '12345'))
          .thenAnswer((_) async => true);

      // 2. ACT: Kita panggil fungsi login
      final result = await authService.loginUser('admin@utd.com', '12345');

      // 3. ASSERT: Buktikan hasilnya true
      expect(result, true);
    });

    test('Login gagal karena form kosong (Tidak butuh internet)', () async {
      // 1. ACT: Sengaja kasih string kosong
      final result = await authService.loginUser('', '');

      // 2. ASSERT: Buktikan hasilnya false
      expect(result, false);
      
      // Buktikan juga bahwa fungsi nembak internet tidak pernah dipanggil sama sekali
      verifyNever(() => stuntman.login(any(), any()));
    });
  });
}