import 'package:food_hub/features/home/domain/entity/PaymentEntity.dart';
import 'package:food_hub/features/home/domain/repository/payment_repository.dart';

class CreatePaymentIntent {
  final PaymentRepository repository;

  CreatePaymentIntent(this.repository);

  Future<String> call(Payment payment) {
    return repository.createPaymentIntent(payment);
  }
}
