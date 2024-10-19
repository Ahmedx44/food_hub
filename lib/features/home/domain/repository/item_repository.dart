import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';

abstract class ItemRepository {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems();

  Future<Either<String, String>> addtocart(CartModel cartModel);
}
