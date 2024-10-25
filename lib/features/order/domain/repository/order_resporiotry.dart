import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class OrderResporiotry {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getAllUserOrders();
}
