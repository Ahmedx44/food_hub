import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/profile/data/source/user_Service.dart';
import 'package:food_hub/features/profile/domain/repository/user_repository.dart';
import 'package:food_hub/service_locator.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      getUserInfo() async {
    return await sl<UserService>().getUserInfo();
  }
}
