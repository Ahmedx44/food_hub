import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/source/cart_service.dart';
import 'package:food_hub/features/cart/domain/repository/cart_repository.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/service_locator.dart';

class CartRepositoryImpl extends CartRepository {
  @override
  Future<Stream<List<CartModel>>> getCartStream() async {
    // Call getCart from CartService and return the list of CartModel
    return sl<CartService>().getCartStream();
  }

  @override
  Future<Either<String, List<CartModel>>> removeItem(String productId) {
    // Call removeItem from CartService and return the updated list of CartModel
    return sl<CartService>().removeItem(productId);
  }
}
