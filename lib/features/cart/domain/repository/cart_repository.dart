import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/domain/entity/cart_entity.dart';

abstract class CartRepository {
  Future<Stream<List<CartItemEntity>>> getCartStream(); // Updated return type
  Future<Either<String, String>> removeItem(String productId);
  Future<Either<String, String>> updateQuantity(String itemid, int quantity);
}
