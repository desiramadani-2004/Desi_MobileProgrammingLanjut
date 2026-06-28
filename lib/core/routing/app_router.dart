import 'package:utd_advanced_app/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:utd_advanced_app/features/product/presentation/pages/product_page.dart';
import 'package:utd_advanced_app/features/product/presentation/pages/detail_page.dart';
import 'package:utd_advanced_app/features/profile/presentation/pages/profile_page.dart';
import 'package:utd_advanced_app/features/product/presentation/cubit/product_cubit.dart';
import 'package:utd_advanced_app/core/di/injection.dart';
import 'package:utd_advanced_app/features/product/presentation/pages/crypto_page.dart';
import 'package:utd_advanced_app/features/todo/presentation/pages/todo_page.dart';
import 'package:utd_advanced_app/features/native/presentation/pages/native_page.dart';
import 'package:utd_advanced_app/features/sync/presentation/pages/background_sync_page.dart';
import 'package:utd_advanced_app/features/animation/presentation/pages/animation_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          // BUNGKUS PRODUCT PAGE DENGAN BLOC PROVIDER
          return BlocProvider(
            // Minta Cubit dari get_it, langsung jalankan fetchAllProducts
            create: (context) => locator<ProductCubit>()..fetchAllProducts(),
            child: const ProductPage(),
          );
        },
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return DetailPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/crypto',
        builder: (context, state) => const CryptoPage(),
      ),
      GoRoute(
        path: '/todo',
        builder: (context, state) => const TodoPage(),
      ),
      GoRoute( 
        path: '/native', 
        builder: (context, state) => const NativePage(), 
      ),
      GoRoute(
        path: '/sync',
        builder: (context, state) => const BackgroundSyncPage(),
      ), 
      GoRoute(
        path: '/animation',
        builder: (context, state) => const AnimationPage(),
      ),

    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Halaman tidak ditemukan!')),
    ),
  );
}