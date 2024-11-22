// domain/entities/cart_item_entity.dart
class CartItemEntity {
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

  CartItemEntity({
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
}
