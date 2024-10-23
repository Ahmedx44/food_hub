import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_hub/core/common/const.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';

abstract class StripeService {
  Future<Either<String, dynamic>> createPaymentIntent(
      int amount, String currency);
  Future<Either<String, dynamic>> makePayment(PaymentModel paymentModel);
}

class StripeServiceImpl extends StripeService {
  @override
  Future<Either<String, dynamic>> createPaymentIntent(
      int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amount *
            100, // Stripe expects the amount in the smallest unit, so multiply by 100 for cents.
        'currency': currency,
      };

      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${StripeKey.stripeSecertKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null && response.data['client_secret'] != null) {
        return Right(
            response.data['client_secret']); // Return the client secret.
      } else {
        return const Left('Failed to create Payment Intent');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, dynamic>> makePayment(PaymentModel paymentModel) async {
    try {
      final paymentIntentResult =
          await createPaymentIntent(paymentModel.amount, paymentModel.currency);

      return await paymentIntentResult.fold(
        (error) async {
          return Left(error);
        },
        (paymentIntentClientSecret) async {
          // Initialize the payment sheet
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentClientSecret,
              style: ThemeMode.light,
              merchantDisplayName: 'Your Business',
            ),
          );

          await Stripe.instance.presentPaymentSheet();

          return Right('Payment successful!');
        },
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
