import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/order_model.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';
import 'package:food_hub/features/cart/data/source/stripe_service.dart';
import 'package:food_hub/features/cart/domain/repository/stripe_repository.dart';
import 'package:food_hub/service_locator.dart';

class StripeRespositoryImpl extends StripeRepository {
  @override
  Future<Either<String, dynamic>> createPaymentIntent(
      double amount, String currency) async {
    return sl<StripeService>().createPaymentIntent(amount, currency);
  }

  @override
  Future<Either<String, dynamic>> makePayment(PaymentModel paymentModel) {
    return sl<StripeService>().makePayment(paymentModel);
  }

  @override
  Future<Either<String, String>> makeOrder(OrderModel orderModel) {
    return sl<StripeService>().makeOrder(orderModel);
  }
}
