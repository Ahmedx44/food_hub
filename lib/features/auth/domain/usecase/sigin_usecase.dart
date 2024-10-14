import 'package:dartz/dartz.dart';
import 'package:food_hub/features/auth/data/model/sigin_model.dart';
import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/service_locator.dart';

class SiginUsecase {
  Future<Either<String, String>> call(SigninModel singinModel) async {
    return await sl<AuthService>().signin(singinModel);
  }
}
