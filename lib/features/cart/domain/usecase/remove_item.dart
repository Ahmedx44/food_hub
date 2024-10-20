import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';
import 'package:food_hub/features/home/domain/entity/cart_entity.dart';
import 'package:food_hub/service_locator.dart';

class RemoveItem {
  Future<Either<String, List<CartItem>>> call(String name) async {
    return await sl<CartRepositoryImpl>().removeItem(name);
  }
}
