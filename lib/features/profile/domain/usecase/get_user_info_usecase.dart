import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_hub/features/profile/domain/repository/user_repository.dart';
import 'package:food_hub/service_locator.dart';

class GetUserInfoUsecase {
  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>>
      call() async {
    return await sl<UserRepository>().getUserInfo();
  }
}
