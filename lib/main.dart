import 'package:flutter/material.dart';
import 'package:utd_advanced_app/core/theme/app_theme.dart';
import 'package:utd_advanced_app/core/routing/app_router.dart';
import 'package:utd_advanced_app/core/di/injection.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      title: 'UTD Advanced App',
      theme: AppTheme.lightTheme,
      // Masukkan konfigurasi rute dari app_router.dart
      routerConfig: AppRouter.router, 
    );
  }
}