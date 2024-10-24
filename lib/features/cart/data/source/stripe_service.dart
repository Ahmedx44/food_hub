import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_hub/core/common/const.dart';
import 'package:food_hub/features/cart/data/model/order_model.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';

abstract class StripeService {
  Future<Either<String, dynamic>> createPaymentIntent(
      double amount, String currency);
  Future<Either<String, dynamic>> makePayment(PaymentModel paymentModel);
  Future<Either<String, String>> makeOrder(OrderModel orderModel);
}

class StripeServiceImpl extends StripeService {
  @override
  Future<Either<String, dynamic>> createPaymentIntent(
      double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amount * 100,
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

          // Present the payment sheet
          await Stripe.instance.presentPaymentSheet();

          // Confirm the payment
          final paymentIntent = await Stripe.instance.confirmPayment(
              paymentIntentClientSecret: paymentIntentClientSecret);

          if (paymentIntent.status == 'succeeded') {
            return const Right('Payment successful!');
          } else if (paymentIntent.status == 'requires_payment_method') {
            return const Left('Payment failed: requires a new payment method.');
          } else {
            return Left('Payment failed: ${paymentIntent.status}');
          }
        },
      );
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> makeOrder(OrderModel orderModel) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      final order = await FirebaseFirestore.instance.collection('Orders').add({
        'user': orderModel.userName,
        'amount': orderModel.amount,
        'item': orderModel.item,
        'location': orderModel.location,
        'addressDescription': orderModel.addressDescription,
        'paymentStatus': orderModel.paymentStatus,
        'orderStatus': orderModel.orderStatus
      });

      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .delete();

      return Right('Order Succesfull');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
