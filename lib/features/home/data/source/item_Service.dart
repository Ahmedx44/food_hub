import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ItemService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems();
}

class ItemServiceImpl extends ItemService {
  final _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems() async {
    try {
      final result = _firebaseFirestore.collection('foods').snapshots();

      return Right(result);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
