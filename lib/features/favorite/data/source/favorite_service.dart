import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FavoriteService {
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getAllFavorites();
}

class FavoriteServiceImpl extends FavoriteService {
  final user = FirebaseAuth.instance.currentUser?.uid;
  @override
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getAllFavorites() async {
    try {
      final result = FirebaseFirestore.instance
          .collection('favorite')
          .doc(user)
          .snapshots();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
