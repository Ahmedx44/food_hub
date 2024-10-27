import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/model/favorite_model.dart';
import 'package:food_hub/features/home/data/repository/item_repository_impl.dart';
import 'package:food_hub/service_locator.dart';

class AddToFavoriteUsecase {
  Future<Either<String, String>> call(FavoriteModel favoriteModel) async {
    return await sl<ItemRepositoryImpl>().addtofavorite(favoriteModel);
  }
}
