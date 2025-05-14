import 'dart:convert';

class Product {
  final int id;
  final String uid;
  final int userId;
  final String name;
  final String description;
  final double price;
  final String image;
  final bool visibility;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.uid,
    required this.userId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      uid: json['uid'],
      userId: int.parse(json['user_id'].toString()),
      name: json['name_product'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'],
      visibility: json['visibility'].toString() == "1",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'user_id': userId,
      'name_product': name,
      'description': description,
      'price': price.toString(),
      'image': image,
      'visibility': visibility ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static List<Product> fromJsonList(String jsonString) {
    Iterable list = json.decode(jsonString);
    return list.map((model) => Product.fromJson(model)).toList();
  }
}
