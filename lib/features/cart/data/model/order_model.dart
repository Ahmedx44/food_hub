import 'package:food_hub/features/cart/data/model/in_cart_model.dart';

import 'package:geolocator/geolocator.dart';

class OrderModel {
  final double amount;
  final String addressDescription;
  final Position location;
  final List<InCartModel> item;
  final String userId;
  final String paymentStatus;
  final String orderStatus;
  final String userName;

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
}
