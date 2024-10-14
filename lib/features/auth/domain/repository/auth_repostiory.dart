import 'package:dartz/dartz.dart';
import 'package:food_hub/features/auth/data/model/sigin_model.dart';
import 'package:food_hub/features/auth/data/model/signup_model.dart';

abstract class AuthRepostiory {
  Future<Either<String, String>> signinwithgoogle();
  Future<Either<String, String>> sigin(SigninModel signinModel);
  Future<Either<String, String>> signup(SignupModel signupModel);
}
