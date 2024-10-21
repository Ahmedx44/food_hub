class CartModel {
  String id;
  String category;
  String description;
  String imageUrl;
  String itemLeft;
  String name;
  String price;
  String rating;
  String quantity;

  CartModel({
    required this.id,
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
