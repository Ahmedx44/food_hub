// data/model/in_cart_model.dart

import 'package:food_hub/features/cart/domain/entity/cart_entity.dart';

class InCartModel {
  final String id;
  final String category;
  final String description;
  final String imageUrl;
  final String itemLeft;
  final String name;
  final double price;
  final String rating;
  final double originalPrice;
  final String quantity;

  InCartModel({
    required this.id,
    required this.originalPrice,
    required this.category,
    required this.quantity,
    required this.description,
    required this.imageUrl,
    required this.itemLeft,
    required this.name,
    required this.price,
    required this.rating,
  });

  // Convert InCartModel to CartItemEntity
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: this.id,
      originalPrice: this.originalPrice,
      category: this.category,
      quantity: this.quantity,
      description: this.description,
      imageUrl: this.imageUrl,
      itemLeft: this.itemLeft,
      name: this.name,
      price: this.price,
      rating: this.rating,
    );
  }

  // Convert InCartModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPrice': originalPrice,
      'category': category,
      'quantity': quantity,
      'description': description,
      'imageUrl': imageUrl,
      'itemLeft': itemLeft,
      'name': name,
      'price': price,
      'rating': rating,
    };
  }

  // Convert a map to InCartModel (deserialization)
  factory InCartModel.fromMap(Map<String, dynamic> map) {
    return InCartModel(
      id: map['id'] ?? '',
      originalPrice: map['originalPrice']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      itemLeft: map['itemLeft'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      rating: map['rating'] ?? '',
    );
  }
}
