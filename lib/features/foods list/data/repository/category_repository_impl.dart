import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/foods%20list/data/model/category_model.dart';
import 'package:food_hub/features/foods%20list/data/source/get_food_by_category.dart';
import 'package:food_hub/features/foods%20list/domain/reposiotry/category_repository.dart';
import 'package:food_hub/service_locator.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getFoodByCategory(CategoryModel categoryModel) async {
    return await sl<CategoryService>().getFoodByCategory(categoryModel);
  }
}
