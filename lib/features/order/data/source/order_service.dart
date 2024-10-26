import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class OrderService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getAllUserOrders();
}

class OrderServiceImpl extends OrderService {
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getAllUserOrders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return Left('User not logged in');
      }

      final result = FirebaseFirestore.instance
          .collection('Orders')
          .where('userId', isEqualTo: user.uid)
          .snapshots();

      return Right(result);
    } catch (e) {
      return Left('Something went Wrong');
    }
  }
}
