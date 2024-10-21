import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';

import 'package:food_hub/service_locator.dart';

class UpdateQuantityUsecase {
  Future<Either<String, String>> call(String itemid, int quantity) async {
    return await sl<CartRepositoryImpl>().updateQuantity(itemid, quantity);
  }
}
