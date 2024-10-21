import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';

abstract class CartRepository {
  Future<Stream<List<CartModel>>> getCartStream(); // Updated return type
  Future<Either<String, List<CartModel>>> removeItem(String productId);
}
