import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/source/item_Service.dart';
import 'package:food_hub/features/home/domain/repository/item_repository.dart';
import 'package:food_hub/service_locator.dart';

class ItemRepositoryImpl extends ItemRepository {
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getPopularItems() {
    return sl<ItemService>().getPopularItems();
  }
}
