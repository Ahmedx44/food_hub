import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/foods%20list/data/model/category_model.dart';

abstract class CategoryRepository {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getFoodByCategory(CategoryModel categoryModel);
}
