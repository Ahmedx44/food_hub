import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/service_locator.dart';

class GetAllCart {
  Future<Stream<List<CartModel>>> call() async {
    return await sl<CartRepositoryImpl>().getCartStream();
  }
}
