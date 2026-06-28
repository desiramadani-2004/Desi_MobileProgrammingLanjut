import 'api_client.dart';

class AuthService {
  final ApiClient apiClient;
  AuthService(this.apiClient);

  // Fungsi yang akan kita tes
  Future<bool> loginUser(String email, String password) async {
    // Cek form kosong
    if (email.isEmpty || password.isEmpty) {
      return false; 
    }
    // Kalau form terisi, suruh ApiClient nembak internet
    return await apiClient.login(email, password);
  }
}