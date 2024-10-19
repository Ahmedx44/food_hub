import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/features/home/data/repository/item_repository_impl.dart';
import 'package:food_hub/service_locator.dart';

class AddToCartUsecase {
  Future<Either<String, String>> call(CartModel cartModel) async {
    return await sl<ItemRepositoryImpl>().addtocart(cartModel);
  }
}
