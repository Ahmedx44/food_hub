import 'package:dartz/dartz.dart';
import 'package:food_hub/features/auth/data/model/signup_model.dart';
import 'package:food_hub/features/auth/data/repository/auth_repository.dart';
import 'package:food_hub/service_locator.dart';

class SingupUsecase {
  Future<Either<String, String>> call(SignupModel signupModel) async {
    return await sl<AuthRepositoryImpl>().signup(signupModel);
  }
}
