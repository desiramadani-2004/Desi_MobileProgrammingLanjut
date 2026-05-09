import 'package:dio/dio.dart';
import '../domain/product_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';

class ProductRepository {
  final ApiClient apiClient = locator<ApiClient>();

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Gagal memuat jaringan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await apiClient.dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}