import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/features/home/domain/entity/cart_entity.dart';
import 'package:hive/hive.dart';

abstract class ItemService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems();
  Future<Either<String, String>> addtocart(CartModel cartModel);
}

class ItemServiceImpl extends ItemService {
  final _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems() async {
    try {
      final result = _firebaseFirestore
          .collection('foods')
          .where('rating', isGreaterThan: 4.6)
          .snapshots();

      return Right(result);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, String>> addtocart(CartModel cartModel) async {
    final box = Hive.box<CartItem>('cart_item');
    try {
      box.add(CartItem(
          category: cartModel.category,
          description: cartModel.description,
          imageUrl: cartModel.imageUrl,
          itemLeft: cartModel.itemLeft,
          name: cartModel.name,
          price: cartModel.price.toString(),
          rating: cartModel.rating.toString()));
      return const Right('Your Item has Been Succesfully Added to Cart');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
