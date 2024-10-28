import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/foods%20list/data/model/category_model.dart';
import 'package:food_hub/features/foods%20list/data/repository/category_repository_impl.dart';
import 'package:food_hub/service_locator.dart';

class GetCategoryUsecase {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>> call(
      CategoryModel categoryModel) async {
    return await sl<CategoryRepositoryImpl>().getFoodByCategory(categoryModel);
  }
}
