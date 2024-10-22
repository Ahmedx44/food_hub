import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';

import 'package:food_hub/service_locator.dart';

class RemoveItem {
  Future<Either<String, String>> call(String id) async {
    return await sl<CartRepositoryImpl>().removeItem(id);
  }
}
