import 'package:dartz/dartz.dart';
import 'package:food_hub/features/auth/data/model/sigin_model.dart';
import 'package:food_hub/features/auth/data/model/signup_model.dart';
import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/features/auth/domain/repository/auth_repostiory.dart';
import 'package:food_hub/service_locator.dart';

class AuthRepositoryImpl extends AuthRepostiory {
  @override
  Future<Either<String, String>> signinwithgoogle() {
    return sl<AuthService>().signinWithGoogle();
  }

  @override
  Future<Either<String, String>> sigin(SigninModel siginModel) async {
    return await sl<AuthService>().signin(siginModel);
  }

  @override
  Future<Either<String, String>> signup(SignupModel signupModel) async {
    return await sl<AuthService>().signup(signupModel);
  }
}
