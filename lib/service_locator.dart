import 'package:food_hub/features/auth/data/source/auth_service.dart';
import 'package:food_hub/features/auth/domain/usecase/reset_usecase.dart';
import 'package:food_hub/features/auth/domain/usecase/sigin_usecase.dart';
import 'package:food_hub/features/auth/domain/usecase/signin_with_google.dart';
import 'package:food_hub/features/auth/domain/usecase/singup_usecase.dart';

import 'package:food_hub/features/cart/data/repository/cart_repository_impl.dart';
import 'package:food_hub/features/cart/data/repository/stripe_respository_impl.dart';
import 'package:food_hub/features/cart/data/source/cart_service.dart';
import 'package:food_hub/features/cart/data/source/stripe_service.dart';
import 'package:food_hub/features/cart/domain/repository/stripe_repository.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/domain/usecase/make_payment_usecase.dart';
import 'package:food_hub/features/cart/domain/usecase/remove_item.dart';
import 'package:food_hub/features/cart/domain/usecase/update_quantity_usecase.dart';
import 'package:food_hub/features/home/data/repository/item_repository_impl.dart';
import 'package:food_hub/features/home/data/repository/location_repositoy_impl.dart';
import 'package:food_hub/features/home/data/source/item_Service.dart';
import 'package:food_hub/features/home/data/source/location_service.dart';
import 'package:food_hub/features/home/domain/usecase/add_to_cart_usecase.dart';
import 'package:food_hub/features/home/domain/usecase/get_item_usecase.dart';
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
  sl.registerSingleton<CartService>(
    CartServiceImpl(),
  );
  sl.registerSingleton<StripeService>(
    StripeServiceImpl(),
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
  sl.registerSingleton<GetItemUsecase>(
    GetItemUsecase(),
  );
  sl.registerSingleton<AddToCartUsecase>(
    AddToCartUsecase(),
  );
  sl.registerSingleton<GetAllCart>(
    GetAllCart(),
  );
  sl.registerSingleton<RemoveItem>(
    RemoveItem(),
  );
  sl.registerSingleton<UpdateQuantityUsecase>(
    UpdateQuantityUsecase(),
  );
  sl.registerSingleton<StripeRepository>(
    StripeRespositoryImpl(),
  );
  sl.registerSingleton<MakePaymentUsecase>(
    MakePaymentUsecase(),
  );

  //Implementation
  sl.registerSingleton<LocationRepositoyImpl>(
    LocationRepositoyImpl(),
  );

  sl.registerSingleton<ItemRepositoryImpl>(
    ItemRepositoryImpl(),
  );
  sl.registerSingleton<CartRepositoryImpl>(
    CartRepositoryImpl(),
  );
}
