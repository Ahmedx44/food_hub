import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';

abstract class CartRepository {
  Future<Stream<List<InCartModel>>> getCartStream(); // Updated return type
  Future<Either<String, List<CartModel>>> removeItem(String productId);
  Future<Either<String, String>> updateQuantity(String itemid, int quantity);
}
