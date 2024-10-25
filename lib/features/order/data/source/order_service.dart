import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class OrderService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getAllUserOrders();
}

class OrderServiceImpl extends OrderService {
  final user = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getAllUserOrders() async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('Orders')
          .where('userId', isEqualTo: user)
          .snapshots();

      return Right(result);
    } catch (e) {
      return Left('Something went Wrong');
    }
  }
}
