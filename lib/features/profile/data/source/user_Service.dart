import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getUserInfo();
}

class UserServiceImpl extends UserService {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getUserInfo() async {
    try {
      final userResult = FirebaseFirestore.instance
          .collection('User')
          .doc(user!.uid)
          .snapshots();

      return Right(userResult);
    } catch (e) {
      return Left('Something went wrong');
    }
  }
}
