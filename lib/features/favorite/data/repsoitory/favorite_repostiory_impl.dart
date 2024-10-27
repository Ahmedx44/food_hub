import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/favorite/data/source/favorite_service.dart';
import 'package:food_hub/features/favorite/domain/repository/favorite_reposiotry.dart';
import 'package:food_hub/service_locator.dart';

class FavoriteRepostioryImpl extends FavoriteReposiotry {
  @override
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getAllFavorites() {
    return sl<FavoriteService>().getAllFavorites();
  }
}
