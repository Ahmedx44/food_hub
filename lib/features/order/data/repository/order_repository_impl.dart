import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/order/data/source/order_service.dart';
import 'package:food_hub/features/order/domain/repository/order_resporiotry.dart';
import 'package:food_hub/service_locator.dart';

class OrderRepositoryImpl extends OrderResporiotry {
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getAllUserOrders() async {
    return await sl<OrderService>().getAllUserOrders();
  }
}
