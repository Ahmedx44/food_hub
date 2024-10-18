import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/features/auth/domain/usecase/reset_usecase.dart';
import 'package:food_hub/features/auth/domain/usecase/sigin_usecase.dart';
import 'package:food_hub/features/auth/domain/usecase/signin_with_google.dart';
import 'package:food_hub/features/auth/domain/usecase/singup_usecase.dart';
import 'package:food_hub/features/home/data/repository/location_repositoy_impl.dart';
import 'package:food_hub/features/home/data/source/item_Service.dart';
import 'package:food_hub/features/home/data/source/location_service.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializedDependency() async {
  //Service
  sl.registerSingleton<AuthService>(
    AuthServiceImpl(),
  );
  sl.registerSingleton<LocationService>(
    LocationServiceImpl(),
  );
  sl.registerSingleton<ItemService>(
    ItemServiceImpl(),
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

  sl.registerSingleton<ResetUsecase>(
    ResetUsecase(),
  );

  sl.registerSingleton<GetLocationUsecase>(
    GetLocationUsecase(),
  );

  //Implementation
  sl.registerSingleton<LocationRepositoyImpl>(
    LocationRepositoyImpl(),
  );
}
