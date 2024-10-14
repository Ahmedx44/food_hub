import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/features/auth/domain/usecase/sigin_usecase.dart';
import 'package:food_hub/features/auth/domain/usecase/signin_with_google.dart';
import 'package:food_hub/features/auth/domain/usecase/singup_usecase.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializedDependency() async {
  //Service
  sl.registerSingleton<AuthService>(
    AuthServiceImpl(),
  );

  //UseCase
  sl.registerSingleton<SigninWithGoogle>(
    SigninWithGoogle(),
  );
  sl.registerSingleton<SingupUsecase>(
    SingupUsecase(),
  );

  sl.registerSingleton<SiginUsecase>(
    SiginUsecase(),
  );
}
