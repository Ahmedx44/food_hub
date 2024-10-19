import 'package:hive/hive.dart';

part 'cart_entity.g.dart'; // For generated file

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  String description;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  String itemLeft;

  @HiveField(4)
  String name;

  @HiveField(5)
  String price;

  @HiveField(6)
  String rating;

  CartItem({
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.itemLeft,
    required this.name,
    required this.price,
    required this.rating,
  });
}
