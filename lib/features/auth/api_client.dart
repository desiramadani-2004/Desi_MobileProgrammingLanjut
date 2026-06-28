class ApiClient {
  // Fungsi ini seolah-olah butuh internet dan waktu loading
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Pura-pura loading internet
    return email == 'admin@utd.com' && password == '12345';
  }
}