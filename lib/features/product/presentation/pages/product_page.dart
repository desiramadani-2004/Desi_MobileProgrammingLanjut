import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog BLOC UTD'),
        actions: [
          // TOMBOL BARU: HALAMAN ANIMASI
          IconButton(
            icon: const Icon(Icons.animation), 
            tooltip: 'Halaman Animasi',
            onPressed: () {
              context.push('/animation'); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud_sync), // Ikon awan sinkronisasi
            tooltip: 'Pengaturan Background', // Teks kecil saat ikon ditahan
            onPressed: () {
              // Berpindah ke halaman sync menggunakan GoRouter
              context.push('/sync'); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_system_daydream),
            onPressed: () => context.push('/native'),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () {
              context.push('/todo');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
    
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. JIKA STATE = LOADING (Tampilkan indikator putar)
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. JIKA STATE = ERROR (Tampilkan pesan error)
          else if (state is ProductError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
            );
          }
          // 3. JIKA STATE = SUKSES (Tampilkan ListView)
          else if (state is ProductLoaded) {
            final products = state.products; // Keluarkan data dari kotaknya!
            
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                    title: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('ID: ${item.id}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.push('/detail/${item.id}');
                    },
                  ),
                );
              },
            );
          }
          
          // Fallback (jika state tidak dikenali)
          return const SizedBox.shrink();
        },
      ),
      // FLOATING ACTION BUTTON SEKARANG ADA DI SINI (Sejajar dengan appBar dan body)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/crypto');
        },
        icon: const Icon(Icons.show_chart),
        label: const Text('Live Crypto'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}