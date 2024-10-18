import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/home/data/source/item_Service.dart';
import 'package:food_hub/service_locator.dart';

class GetItemUsecase {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      call() async {
    return sl<ItemService>().getPopularItems();
  }
}
