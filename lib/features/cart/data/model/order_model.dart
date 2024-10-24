import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:geolocator/geolocator.dart';

class OrderModel {
  final double amount;
  final String addressDescription;
  final Position location;
  final List<InCartModel> item; // Ensure this is List<InCartModel>
  final String userId;
  final String paymentStatus;
  final String orderStatus;
  final String? userName;

  OrderModel({
    required this.amount,
    required this.addressDescription,
    required this.location,
    required this.item,
    required this.userId,
    required this.paymentStatus,
    required this.orderStatus,
    required this.userName,
  });

  // Convert OrderModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'addressDescription': addressDescription,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      // Convert each InCartModel to a map
      'item': item.map((e) => e.toMap()).toList(),
      'userId': userId,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'userName': userName,
    };
  }
}
