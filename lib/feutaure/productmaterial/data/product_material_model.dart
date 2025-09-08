// class RawMaterial {
//   final int rawMaterialId;
//   final String name;
//   final String description;
//   final double price;
//   final String status;
//   final double minimumStockAlert;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   RawMaterial({
//     required this.rawMaterialId,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.status,
//     required this.minimumStockAlert,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RawMaterial.fromJson(Map<String, dynamic> json) {
//     return RawMaterial(
//       rawMaterialId: json['raw_material_id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       price: double.parse(json['price'].toString()),
//       status: json['status'] as String,
//       minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//     );
//   }
// }

// // نموذج لشبه المنتج، مشابه لنموذج المنتج ولكن قد يكون له استخدامات مختلفة
// class SemiProduct {
//   final int productId; // يُستخدم product_id كمعرف لشبه المنتج أيضًا
//   final String name;
//   final String description;
//   final double price;
//   final String category;
//   final double weightPerUnit;
//   final double minimumStockAlert;
//   // final String? imagePath;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   SemiProduct({
//     required this.productId,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.category,
//     required this.weightPerUnit,
//     required this.minimumStockAlert,
//     // this.imagePath,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory SemiProduct.fromJson(Map<String, dynamic> json) {
//     return SemiProduct(
//       productId: json['product_id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       price: double.parse(json['price'].toString()),
//       category: json['category'] as String,
//       weightPerUnit: double.parse(json['weight_per_unit'].toString()),
//       minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
//       // imagePath: json['image_path'] as String?,
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//     );
//   }
// }

// // النموذج الرئيسي الذي يمثل كل عنصر في استجابة product_rawmaterial API
// class ProductMaterialRelationship {
//   final int productMaterialId;
//   final int productId;
//   final int? semiProductId;
//   final int? rawMaterialId;
//   final String componentType;
//   final double quantityRequiredPerUnit;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final Product1? product; // 🚨 تم جعلها قابلة للقيمة الفارغة
//   final RawMaterial? rawMaterial;
//   final SemiProduct? semiProduct;

//   ProductMaterialRelationship({
//     required this.productMaterialId,
//     required this.productId,
//     this.semiProductId,
//     this.rawMaterialId,
//     required this.componentType,
//     required this.quantityRequiredPerUnit,
//     required this.createdAt,
//     required this.updatedAt,
//     this.product, // 🚨 تم جعلها قابلة للقيمة الفارغة
//     this.rawMaterial,
//     this.semiProduct,
//   });
//   factory ProductMaterialRelationship.fromJson(Map<String, dynamic> json) {
//     return ProductMaterialRelationship(
//       productMaterialId: json['product_material_id'] as int,
//       productId: json['product_id'] as int,
//       semiProductId: json['semi_product_id'] as int?,
//       rawMaterialId: json['raw_material_id'] as int?,
//       componentType: json['component_type'] as String,
//       quantityRequiredPerUnit:
//           double.parse(json['quantity_required_per_unit'].toString()),
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at']
//           as String), // التحقق من عدم وجود قيمة فارغة قبل التحويل
//       product: (json['product'] != null)
//           ? Product1.fromJson(json['product'] as Map<String, dynamic>)
//           : null,
//       rawMaterial: (json['raw_material'] != null)
//           ? RawMaterial.fromJson(json['raw_material'] as Map<String, dynamic>)
//           : null,
//       semiProduct: (json['semi_product'] != null)
//           ? SemiProduct.fromJson(json['semi_product'] as Map<String, dynamic>)
//           : null,
//     );
//   }
// }

// class Product1 {
//   final int productId;
//   final String name;
//   final String? description; // 💡 تم جعلها قابلة للقيم الفارغة
//   final double price;
//   final String category;
//   final double weightPerUnit;
//   final double minimumStockAlert;
//   final String? imagePath;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   // final List<ProductMaterial> productMaterials; // 🚨 قم بإزالة هذا السطر

//   Product1({
//     required this.productId,
//     required this.name,
//     this.description, // أعدت الوصف
//     required this.price,
//     required this.category,
//     required this.weightPerUnit,
//     required this.minimumStockAlert,
//     this.imagePath,
//     required this.createdAt,
//     required this.updatedAt,
//     // required this.productMaterials, // 🚨 قم بإزالة هذا السطر
//   });

//   factory Product1.fromJson(Map<String, dynamic> json) {
//     // 🚨 قم بإزالة هذا الجزء بالكامل
//     // var productMaterialsList = json['product_materials'] as List;
//     // List<ProductMaterial> materials = productMaterialsList
//     //     .map((materialJson) => ProductMaterial.fromJson(materialJson))
//     //     .toList();

//     return Product1(
//       productId: json['product_id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String?, // تأكد من وجوده في الـ JSON
//       price: double.parse(json['price'].toString()),
//       category: json['category'] as String,
//       weightPerUnit: double.parse(json['weight_per_unit'].toString()),
//       minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
//       imagePath: json['image_path'] as String?,
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//       // productMaterials: materials, // 🚨 قم بإزالة هذا السطر
//     );

class RawMaterial {
  final int rawMaterialId;
  final String name;
  final String? description;
  final double price;
  final String status;
  final double minimumStockAlert;
  final DateTime createdAt;
  final DateTime updatedAt;

  RawMaterial({
    required this.rawMaterialId,
    required this.name,
    this.description,
    required this.price,
    required this.status,
    required this.minimumStockAlert,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RawMaterial.fromJson(Map<String, dynamic> json) => RawMaterial(
        rawMaterialId: json['raw_material_id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: double.parse(json['price'].toString()),
        status: json['status'] as String,
        minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}

class SemiProduct {
  final int productId;
  final String name;
  final String? description;
  final double price;
  final String category;
  final double weightPerUnit;
  final double minimumStockAlert;
  final DateTime createdAt;
  final DateTime updatedAt;

  SemiProduct({
    required this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    required this.weightPerUnit,
    required this.minimumStockAlert,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SemiProduct.fromJson(Map<String, dynamic> json) => SemiProduct(
        productId: json['product_id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: double.parse(json['price'].toString()),
        category: json['category'] as String,
        weightPerUnit: double.parse(json['weight_per_unit'].toString()),
        minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}

class Product1 {
  final int productId;
  final String name;
  final String? description;
  final double price;
  final String category;
  final double weightPerUnit;
  final double minimumStockAlert;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product1({
    required this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    required this.weightPerUnit,
    required this.minimumStockAlert,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product1.fromJson(Map<String, dynamic> json) => Product1(
        productId: json['product_id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: double.parse(json['price'].toString()),
        category: json['category'] as String,
        weightPerUnit: double.parse(json['weight_per_unit'].toString()),
        minimumStockAlert: double.parse(json['minimum_stock_alert'].toString()),
        imagePath: json['image_path'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}

class ProductMaterialRelationship {
  final int productMaterialId;
  final int productId;
  final int? semiProductId;
  final int? rawMaterialId;
  final String componentType;
  final double quantityRequiredPerUnit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product1? product;
  final RawMaterial? rawMaterial;
  final SemiProduct? semiProduct;

  ProductMaterialRelationship({
    required this.productMaterialId,
    required this.productId,
    this.semiProductId,
    this.rawMaterialId,
    required this.componentType,
    required this.quantityRequiredPerUnit,
    required this.createdAt,
    required this.updatedAt,
    this.product,
    this.rawMaterial,
    this.semiProduct,
  });

  factory ProductMaterialRelationship.fromJson(Map<String, dynamic> json) =>
      ProductMaterialRelationship(
        productMaterialId: json['product_material_id'] as int,
        productId: json['product_id'] as int,
        semiProductId: json['semi_product_id'] as int?,
        rawMaterialId: json['raw_material_id'] as int?,
        componentType: json['component_type'] as String,
        quantityRequiredPerUnit:
            double.parse(json['quantity_required_per_unit'].toString()),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        product: json['product'] != null
            ? Product1.fromJson(json['product'] as Map<String, dynamic>)
            : null,
        rawMaterial: json['raw_material'] != null
            ? RawMaterial.fromJson(json['raw_material'] as Map<String, dynamic>)
            : null,
        semiProduct: json['semi_product'] != null
            ? SemiProduct.fromJson(json['semi_product'] as Map<String, dynamic>)
            : null,
      );
}

//   }
// }
