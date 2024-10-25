import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/order/domain/repository/order_resporiotry.dart';
import 'package:food_hub/service_locator.dart';

class GetUserOrdersUseCase {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      call() async {
    return await sl<OrderResporiotry>().getAllUserOrders();
  }
}
