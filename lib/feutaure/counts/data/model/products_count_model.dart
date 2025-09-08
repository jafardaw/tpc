// lib/features/products_count/data/models/products_count_model.dart
class ProductsCountModel {
  final String count;

  ProductsCountModel({required this.count});

  factory ProductsCountModel.fromJson(String json) {
    return ProductsCountModel(count: json);
  }
}
