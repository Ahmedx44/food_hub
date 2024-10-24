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

  // Convert InCartModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalprice': originalprice,
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
}
