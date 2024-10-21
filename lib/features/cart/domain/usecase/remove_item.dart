import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';

import 'package:food_hub/service_locator.dart';

class RemoveItem {
  Future<Either<String, List<CartModel>>> call(String id) async {
    return await sl<CartRepositoryImpl>().removeItem(id);
  }
}
