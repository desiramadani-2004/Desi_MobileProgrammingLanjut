import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utd_advanced_app/core/config/env_config.dart'; // 1. IMPORT ENV CONFIG DI SINI
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 2. JUDUL DINAMIS BERDASARKAN ENVIRONMENT
        title: Text(
          EnvConfig.isProduction ? 'Katalog UTD [PRODUCTION]' : 'Katalog UTD [DEV]',
        ),
        // 3. WARNA HEADER DINAMIS (Prod = Hijau, Dev = Biru Gelap)
        backgroundColor: EnvConfig.isProduction ? Colors.green.shade800 : Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.animation), 
            tooltip: 'Halaman Animasi',
            onPressed: () {
              context.push('/animation'); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud_sync), 
            tooltip: 'Pengaturan Background', 
            onPressed: () {
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
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is ProductError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
            );
          }
          else if (state is ProductLoaded) {
            final products = state.products; 
            
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
          return const SizedBox.shrink();
        },
      ),
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