import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/data/source/cart_service.dart';
import 'package:food_hub/features/cart/domain/repository/cart_repository.dart';
import 'package:food_hub/service_locator.dart';

class CartRepositoryImpl extends CartRepository {
  @override
  Future<Stream<List<InCartModel>>> getCartStream() async {
    return sl<CartService>().getCartStream();
  }

  @override
  Future<Either<String, String>> removeItem(String productId) {
    return sl<CartService>().removeItem(productId);
  }

  @override
  Future<Either<String, String>> updateQuantity(String itemid, int quantity) {
    return sl<CartService>().updateQuantity(itemid, quantity);
  }
}
