import 'package:food_hub/features/home/domain/entity/PaymentEntity.dart';

abstract class PaymentRepository {
  Future<String> createPaymentIntent(Payment payment);
}
