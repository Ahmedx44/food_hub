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
  //Service
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<LocationService>(LocationServiceImpl());
  sl.registerSingleton<ItemService>(ItemServiceImpl());
  sl.registerSingleton<CartService>(CartServiceImpl());
  sl.registerSingleton<StripeService>(StripeServiceImpl());
  sl.registerSingleton<OrderService>(OrderServiceImpl());
  sl.registerSingleton<UserService>(UserServiceImpl());
  sl.registerSingleton<FavoriteService>(FavoriteServiceImpl());
  sl.registerSingleton<CategoryService>(CategoryServiceImpl());

  //UseCase
  sl.registerSingleton<SigninWithGoogle>(SigninWithGoogle());
  sl.registerSingleton<SingupUsecase>(SingupUsecase());
  sl.registerSingleton<SiginUsecase>(SiginUsecase());
  sl.registerSingleton<ResetUsecase>(ResetUsecase());
  sl.registerSingleton<GetLocationUsecase>(GetLocationUsecase());
  sl.registerSingleton<GetItemUsecase>(GetItemUsecase());
  sl.registerSingleton<AddToCartUsecase>(AddToCartUsecase());
  sl.registerSingleton<GetAllCart>(GetAllCart());
  sl.registerSingleton<RemoveItem>(RemoveItem());
  sl.registerSingleton<UpdateQuantityUsecase>(UpdateQuantityUsecase());
  sl.registerSingleton<StripeRepository>(StripeRespositoryImpl());
  sl.registerSingleton<MakePaymentUsecase>(MakePaymentUsecase());
  sl.registerSingleton<MakeOrderUsecase>(MakeOrderUsecase());
  sl.registerSingleton<GetUserOrdersUseCase>(GetUserOrdersUseCase());
  sl.registerSingleton<GetUserInfoUsecase>(GetUserInfoUsecase());
  sl.registerSingleton<AddToFavoriteUsecase>(AddToFavoriteUsecase());
  sl.registerSingleton<GetUserFavoriteUsecase>(GetUserFavoriteUsecase());
  sl.registerSingleton<GetCategoryUsecase>(GetCategoryUsecase());

  //Implementation
  sl.registerSingleton<LocationRepositoyImpl>(LocationRepositoyImpl());
  sl.registerSingleton<ItemRepositoryImpl>(ItemRepositoryImpl());
  sl.registerSingleton<CartRepositoryImpl>(CartRepositoryImpl());
  sl.registerSingleton<OrderResporiotry>(OrderRepositoryImpl());
  sl.registerSingleton<UserRepository>(UserRepositoryImpl());
  sl.registerSingleton<FavoriteRepostioryImpl>(FavoriteRepostioryImpl());
  sl.registerSingleton<CategoryRepositoryImpl>(CategoryRepositoryImpl());
}
