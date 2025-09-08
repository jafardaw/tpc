// lib/feutaure/product/data/product_model.dart

import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp212/feutaure/simi_products/data/model/simi_product_model.dart';

class ProductMaterial {
  final int productMaterialId;
  final int productId;
  final int? semiProductId; // Made nullable with '?'
  final int? rawMaterialId; // Made nullable with '?'
  final String componentType;
  final double quantityRequiredPerUnit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GetRawMaterialModel? getRawMaterialModel;
  final SimiProductModel? simiProductModel;
  // خليه nullable

  ProductMaterial({
    required this.productMaterialId,
    required this.productId,
    this.semiProductId, // No 'required' for nullable fields
    this.rawMaterialId, // No 'required' for nullable fields
    required this.componentType,
    required this.quantityRequiredPerUnit,
    required this.createdAt,
    required this.updatedAt,
    required this.getRawMaterialModel,
    required this.simiProductModel,
  });

  factory ProductMaterial.fromJson(Map<String, dynamic> json) {
    return ProductMaterial(
      productMaterialId: json['product_material_id'] as int,
      productId: json['product_id'] as int,
      semiProductId: json['semi_product_id'] as int?,
      rawMaterialId: json['raw_material_id'] as int?,
      componentType: json['component_type'] as String,
      quantityRequiredPerUnit: double.parse(
        json['quantity_required_per_unit'].toString(),
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      // المفتاح في الريسبونس اسمه raw_material
      getRawMaterialModel: json['raw_material'] != null
          ? GetRawMaterialModel.fromJson(
              json['raw_material'] as Map<String, dynamic>,
            )
          : null, // لو null ما يحاول يحوله

      simiProductModel: json['semi_product'] != null
          ? SimiProductModel.fromJson(
              json['semi_product'] as Map<String, dynamic>,
            )
          : null, // لو null
    );
  }
}

class Product {
  final int productId;
  final String name;
  // final String description;
  final double price;
  final String category;
  final double weightPerUnit;
  final double minimumStockAlert;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductMaterial> productMaterials;

  Product({
    required this.productId,
    required this.name,
    // required this.description,
    required this.price,
    required this.category,
    required this.weightPerUnit,
    required this.minimumStockAlert,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.productMaterials,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var productMaterialsList = json['product_materials'] as List;
    List<ProductMaterial> materials = productMaterialsList
        .map((materialJson) => ProductMaterial.fromJson(materialJson))
        .toList();

    return Product(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      // description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      category: json['category'] as String,
      weightPerUnit: double.parse(json['weight_per_unit'].toString()),
      minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
      imagePath: json['image_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      productMaterials: materials,
    );
  }
}
