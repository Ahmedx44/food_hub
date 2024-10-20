import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/source/cart_service.dart';

import 'package:food_hub/features/cart/domain/repository/cart_repository.dart';
import 'package:food_hub/features/home/domain/entity/cart_entity.dart';
import 'package:food_hub/service_locator.dart';

class CartRepositoryImpl extends CartRepository {
  @override
  Future<Either<String, List<CartItem>>> getcart() async {
    return sl<CartService>().getCart();
  }

  @override
  Future<Either<String, List<CartItem>>> removeItem(String name) {
    return sl<CartService>().removeItem(name);
  }
}
