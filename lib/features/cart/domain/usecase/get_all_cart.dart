import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';
import 'package:food_hub/features/cart/domain/entity/cart_entity.dart';
import 'package:food_hub/service_locator.dart';

class GetAllCart {
  Future<Stream<List<CartItemEntity>>> call() async {
    return await sl<CartRepositoryImpl>().getCartStream();
  }
}
