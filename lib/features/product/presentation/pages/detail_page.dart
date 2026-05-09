import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:utd_advanced_app/core/di/injection.dart';
import 'package:utd_advanced_app/features/product/domain/product_service.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final service = locator<ProductService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      // Gunakan FutureBuilder untuk menunggu data dari internet
      body: FutureBuilder(
        future: service.fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Maaf, produk tidak ditemukan atau error!'));
          }

          final product = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(product.image, height: 200, fit: BoxFit.contain),
                const SizedBox(height: 20),
                Text('ID Produk: ${product.id}', style: const TextStyle(fontSize: 16)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    product.name, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Kembali'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}