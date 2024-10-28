import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_hub/features/cart/data/model/order_model.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';

abstract class StripeService {
  Future<Either<String, dynamic>> createPaymentIntent(
      int amount, String currency);
  Future<Either<String, dynamic>> makePayment(
      PaymentModel paymentModel, OrderModel orderModel);
  Future<Either<String, String>> makeOrder(OrderModel orderModel);
}

class StripeServiceImpl extends StripeService {
  @override
  Future<Either<String, dynamic>> createPaymentIntent(
      int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amount * 100,
        'currency': currency,
      };

      final keyDoc =
          await FirebaseFirestore.instance.collection('key').doc('key').get();
      final secretKey = keyDoc.data()?['secert_key'];

      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null && response.data['client_secret'] != null) {
        return Right(response.data['client_secret']);
      } else {
        return const Left('Failed to create Payment Intent');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, dynamic>> makePayment(
      PaymentModel paymentModel, OrderModel orderModel) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Left('User is not authenticated.');
    }

    try {
      // Step 1: Create the Payment Intent
      final paymentIntentResult = await createPaymentIntent(
        paymentModel.amount,
        paymentModel.currency,
      );

      return await paymentIntentResult.fold(
        (error) async {
          return Left(error);
        },
        (paymentIntentClientSecret) async {
          // Step 2: Initialize the payment sheet
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentClientSecret,
              merchantDisplayName: 'Your Business',
            ),
          );

          await Stripe.instance.presentPaymentSheet();

          final orderResult = await makeOrder(orderModel);

          return orderResult.fold(
            (orderError) => Left(orderError),
            (successMessage) => const Right('Payment and order successful!'),
          );
        },
      );
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> makeOrder(OrderModel orderModel) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Left('User is not authenticated.');
    }

    try {
      // Add the order to Firestore
      await FirebaseFirestore.instance
          .collection('Orders')
          .add(orderModel.toMap());

      // Clear the user's cart
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .delete();

      return const Right('Order Successful');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
