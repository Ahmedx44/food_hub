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
import 'package:food_hub/features/cart/domain/usecase/make_order_usecase.dart';
import 'package:food_hub/features/cart/domain/usecase/make_payment_usecase.dart';
import 'package:food_hub/features/cart/domain/usecase/remove_item.dart';
import 'package:food_hub/features/cart/domain/usecase/update_quantity_usecase.dart';
import 'package:food_hub/features/favorite/data/repsoitory/favorite_repostiory_impl.dart';
import 'package:food_hub/features/favorite/data/source/favorite_service.dart';
import 'package:food_hub/features/favorite/domain/usecase/get_user_favorite_usecase.dart';
import 'package:food_hub/features/foods%20list/data/repository/category_repository_impl.dart';
import 'package:food_hub/features/foods%20list/data/source/get_food_by_category.dart';
import 'package:food_hub/features/foods%20list/domain/usecase/get_category_usecase.dart';
import 'package:food_hub/features/home/data/repository/item_repository_impl.dart';
import 'package:food_hub/features/home/data/repository/location_repositoy_impl.dart';
import 'package:food_hub/features/home/data/source/item_Service.dart';
import 'package:food_hub/features/home/data/source/location_service.dart';
import 'package:food_hub/features/home/domain/usecase/add_to_cart_usecase.dart';
import 'package:food_hub/features/home/domain/usecase/add_to_favorite.dart';
import 'package:food_hub/features/home/domain/usecase/get_item_usecase.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/features/order/data/repository/order_repository_impl.dart';
import 'package:food_hub/features/order/data/source/order_service.dart';
import 'package:food_hub/features/order/domain/repository/order_resporiotry.dart';
import 'package:food_hub/features/order/domain/usecase/get_user_orders.dart';
import 'package:food_hub/features/profile/data/repository/user_repository_impl.dart';
import 'package:food_hub/features/profile/data/source/user_Service.dart';
import 'package:food_hub/features/profile/domain/repository/user_repository.dart';
import 'package:food_hub/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializedDependency() async {
  // Register LocationService as a singleton, since it was requested not to change
  sl.registerSingleton<LocationService>(LocationServiceImpl());

  // Service: Use registerLazySingleton for other services
  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  sl.registerLazySingleton<ItemService>(() => ItemServiceImpl());
  sl.registerLazySingleton<CartService>(() => CartServiceImpl());
  sl.registerLazySingleton<StripeService>(() => StripeServiceImpl());
  sl.registerLazySingleton<OrderService>(() => OrderServiceImpl());
  sl.registerLazySingleton<UserService>(() => UserServiceImpl());
  sl.registerLazySingleton<FavoriteService>(() => FavoriteServiceImpl());
  sl.registerLazySingleton<CategoryService>(() => CategoryServiceImpl());

  // UseCase: Use registerLazySingleton for all use cases
  sl.registerLazySingleton<SigninWithGoogle>(() => SigninWithGoogle());
  sl.registerLazySingleton<SingupUsecase>(() => SingupUsecase());
  sl.registerLazySingleton<SiginUsecase>(() => SiginUsecase());
  sl.registerLazySingleton<ResetUsecase>(() => ResetUsecase());
  sl.registerLazySingleton<GetLocationUsecase>(() => GetLocationUsecase());
  sl.registerLazySingleton<GetItemUsecase>(() => GetItemUsecase());
  sl.registerLazySingleton<AddToCartUsecase>(() => AddToCartUsecase());
  sl.registerLazySingleton<GetAllCart>(() => GetAllCart());
  sl.registerLazySingleton<RemoveItem>(() => RemoveItem());
  sl.registerLazySingleton<UpdateQuantityUsecase>(
      () => UpdateQuantityUsecase());
  sl.registerLazySingleton<StripeRepository>(() => StripeRespositoryImpl());
  sl.registerLazySingleton<MakePaymentUsecase>(() => MakePaymentUsecase());
  sl.registerLazySingleton<MakeOrderUsecase>(() => MakeOrderUsecase());
  sl.registerLazySingleton<GetUserOrdersUseCase>(() => GetUserOrdersUseCase());
  sl.registerLazySingleton<GetUserInfoUsecase>(() => GetUserInfoUsecase());
  sl.registerLazySingleton<AddToFavoriteUsecase>(() => AddToFavoriteUsecase());
  sl.registerLazySingleton<GetUserFavoriteUsecase>(
      () => GetUserFavoriteUsecase());
  sl.registerLazySingleton<GetCategoryUsecase>(() => GetCategoryUsecase());

  // Implementation: Use registerLazySingleton for all repository implementations
  sl.registerLazySingleton<LocationRepositoyImpl>(
      () => LocationRepositoyImpl());
  sl.registerLazySingleton<ItemRepositoryImpl>(() => ItemRepositoryImpl());
  sl.registerLazySingleton<CartRepositoryImpl>(() => CartRepositoryImpl());
  sl.registerLazySingleton<OrderResporiotry>(() => OrderRepositoryImpl());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  sl.registerLazySingleton<FavoriteRepostioryImpl>(
      () => FavoriteRepostioryImpl());
  sl.registerLazySingleton<CategoryRepositoryImpl>(
      () => CategoryRepositoryImpl());
}
