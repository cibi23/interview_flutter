import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Product {
  final int? id;
  final String? name;
  final int? price;
  final String? description;
  final int? percent;
  final int? stock;
  final List<String>? imageUrls;

  Product(this.id, this.name, this.price, this.description, this.percent,
      this.stock, this.imageUrls);
  factory Product.fromJson(Map<String, dynamic> obj) => _productFromJson(obj);
}

Product _productFromJson(Map<String, dynamic> json) => Product(
      json['id'] as int?,
      json['name'] as String?,
      json['price'] as int?,
      json['description'] as String?,
      json['percent'] as int?,
      json['stock'] as int?,
      json['imageUrls'] as List<String>?,
    );
