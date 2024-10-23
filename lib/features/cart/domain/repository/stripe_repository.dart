import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';

abstract class StripeRepository {
  Future<Either<String, dynamic>> createPaymentIntent(
      int amount, String currency);
  Future<Either<String, dynamic>> makePayment(PaymentModel paymentModel);
}
