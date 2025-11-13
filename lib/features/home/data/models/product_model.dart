import 'package:e_commerce_final/core/utils/media_utils.dart';

class ProductModel {
  final String id;
  final String name;
  final String desc;
  final String image;
  final double price;
  final double? beforeDiscount;
  final int? discountPercentage;
  final String? categoryId;
  final List<String> gallery;
  final bool isAvailable;
  final String? sku;
  final int? quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    this.beforeDiscount,
    this.discountPercentage,
    this.categoryId,
    this.gallery = const [],
    this.isAvailable = true,
    this.sku,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;
    final comparePrice = (json['compare_price'] as num?)?.toDouble();
    final discount = (comparePrice != null && comparePrice > 0)
        ? (((comparePrice - price) / comparePrice) * 100).round()
        : null;
    final images = (json['images'] as List<dynamic>? ?? [])
        .map((image) => resolveMediaUrl(image?.toString()))
        .where((image) => image.isNotEmpty)
        .toList();
    final mainImage = resolveMediaUrl(
      json['main_image'] as String? ??
          (images.isNotEmpty ? images.first : null),
    );

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      desc: json['description'] as String? ?? '',
      image: mainImage,
      price: price,
      beforeDiscount: comparePrice,
      discountPercentage: discount,
      categoryId: json['category_id']?.toString(),
      gallery: images,
      isAvailable: json['is_available'] as bool? ?? true,
      sku: json['sku']?.toString(),
      quantity: json['quantity'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': desc,
      'price': price,
      'compare_price': beforeDiscount,
      'category_id': categoryId,
      'images': gallery,
      'main_image': image,
      'is_available': isAvailable,
      'sku': sku,
      'quantity': quantity,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ProductsModels {
  final List<ProductModel> products;
  final int count;
  final String? next;
  final String? previous;

  ProductsModels({
    required this.products,
    this.count = 0,
    this.next,
    this.previous,
  });

  factory ProductsModels.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>? ?? [];
    return ProductsModels(
      products: results
          .map(
            (product) => ProductModel.fromJson(product as Map<String, dynamic>),
          )
          .toList(),
      count: json['count'] as int? ?? results.length,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
    );
  }
}
