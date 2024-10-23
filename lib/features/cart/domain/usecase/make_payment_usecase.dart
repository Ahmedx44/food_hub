import 'package:dartz/dartz.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';
import 'package:food_hub/features/cart/domain/repository/stripe_repository.dart';
import 'package:food_hub/service_locator.dart';

class MakePaymentUsecase {
  Future<Either<String, dynamic>> call(PaymentModel paymentModel) async {
    return await sl<StripeRepository>().makePayment(paymentModel);
  }
}
