class Product {
  final String id;
  final String name;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  // Mengubah JSON dari API menjadi Objek Dart
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Tanpa Nama',
      image: json['image'] ?? '',
    );
  }
}