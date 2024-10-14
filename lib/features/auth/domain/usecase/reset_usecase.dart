import 'package:dartz/dartz.dart';
import 'package:food_hub/features/auth/data/model/reset_model.dart';
import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/service_locator.dart';

class ResetUsecase {
  Future<Either<String, String>> call(ResetModel resetModel) async {
    return await sl<AuthServiceImpl>().resetPassword(resetModel);
  }
}
