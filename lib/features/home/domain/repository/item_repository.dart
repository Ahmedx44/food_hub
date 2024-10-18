import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ItemRepository {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems();
}
