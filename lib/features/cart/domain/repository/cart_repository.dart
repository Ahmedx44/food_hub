import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';

abstract class CartRepository {
  Future<Stream<List<InCartModel>>> getCartStream(); // Updated return type
  Future<Either<String, String>> removeItem(String productId);
  Future<Either<String, String>> updateQuantity(String itemid, int quantity);
}
