import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';
import '../../features/product/presentation/cubit/product_cubit.dart'; 

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiClient>(() => ApiClient());
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
  locator.registerFactory<ProductService>(() => ProductService(locator()));
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator())); 
}