import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/repository/item_repository_impl.dart';
import 'package:food_hub/service_locator.dart';

class GetFavoroiteItemUseCase {
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      call() async {
    return await sl<ItemRepositoryImpl>().getFavoriteItems();
  }
}
