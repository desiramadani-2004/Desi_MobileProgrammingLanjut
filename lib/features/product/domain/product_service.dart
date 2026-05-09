import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;

  ProductService(this.repository);

  Future<List<Product>> fetchProducts() async {
    return await repository.getAllProducts();
  }

  Future<Product?> fetchProductDetail(String id) async {
    return await repository.getProductById(id);
  }
}