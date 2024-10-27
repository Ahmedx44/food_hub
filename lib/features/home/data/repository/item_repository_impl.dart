import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/features/home/data/model/favorite_model.dart';
import 'package:food_hub/features/home/data/source/item_Service.dart';
import 'package:food_hub/features/home/domain/repository/item_repository.dart';
import 'package:food_hub/service_locator.dart';

class ItemRepositoryImpl extends ItemRepository {
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems() {
    return sl<ItemService>().getPopularItems();
  }

  @override
  Future<Either<String, String>> addtocart(CartModel cartModel) {
    return sl<ItemService>().addtocart(cartModel);
  }

  @override
  Future<Either<String, String>> addtofavorite(FavoriteModel favoriteModel) {
    return sl<ItemService>().addtofavorite(favoriteModel);
  }

  @override
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getFavoriteItems() {
    return sl<ItemService>().getFavoriteItems();
  }
}
