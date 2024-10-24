import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/order_model.dart';
import 'package:food_hub/features/cart/domain/repository/stripe_repository.dart';
import 'package:food_hub/service_locator.dart';

class MakeOrderUsecase {
  Future<Either<String, String>> call(OrderModel orderModel) async {
    return await sl<StripeRepository>().makeOrder(orderModel);
  }
}
