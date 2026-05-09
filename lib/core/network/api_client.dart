import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio dio;
  final Logger logger = Logger();

  ApiClient() : dio = Dio() {
    // 1. Konfigurasi Dasar
    dio.options.baseUrl = 'https://fakestoreapi.com'; // API publik gratis
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // 2. Menambahkan Interceptor (Satpam)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i('MENGIRIM REQUEST: [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.t('BERHASIL [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e('X ERROR [${e.response?.statusCode}]: ${e.requestOptions.uri}\nPESAN: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}