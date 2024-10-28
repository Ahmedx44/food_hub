import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/foods%20list/data/model/category_model.dart';

abstract class CategoryService {
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getFoodByCategory(CategoryModel categoryModel);
}

class CategoryServiceImpl extends CategoryService {
  @override
  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>>
      getFoodByCategory(CategoryModel categoryModel) async {
    try {
      final result = FirebaseFirestore.instance
          .collection('foods')
          .where('category', isEqualTo: categoryModel.categoryName)
          .snapshots();

      return Right(result);
    } catch (e) {
      return Left("Failed to fetch food by category: ${e.toString()}");
    }
  }
}
