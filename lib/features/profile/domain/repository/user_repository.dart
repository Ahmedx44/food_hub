import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getUserInfo();
}
