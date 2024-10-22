class InCartModel {
  String id;
  String category;
  String description;
  String imageUrl;
  String itemLeft;
  String name;
  double price;
  String rating;
  double originalprice;
  String quantity;

  InCartModel({
    required this.id,
    required this.originalprice,
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
