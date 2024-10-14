import 'package:dartz/dartz.dart';
import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/service_locator.dart';

class SigninWithGoogle {
  Future<Either<String, String>> call() async {
    return await sl<AuthService>().signinWithGoogle();
  }
}
