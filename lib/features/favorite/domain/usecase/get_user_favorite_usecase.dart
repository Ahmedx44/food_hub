import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/favorite/data/repsoitory/favorite_repostiory_impl.dart';
import 'package:food_hub/service_locator.dart';

class GetUserFavoriteUsecase {
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      call() async {
    return await sl<FavoriteRepostioryImpl>().getAllFavorites();
  }
}
