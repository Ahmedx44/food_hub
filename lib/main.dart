import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_hub/core/common/bloc/theme_bloc/theme_cubit.dart';
import 'package:food_hub/core/common/const.dart';
import 'package:food_hub/core/theme/theme.dart';
import 'package:food_hub/features/auth/presentation/pages/auth_gate.dart';
import 'package:food_hub/features/auth/presentation/pages/forget_password_page.dart';
import 'package:food_hub/features/auth/presentation/pages/login.dart';
import 'package:food_hub/features/auth/presentation/pages/signup.dart';
import 'package:food_hub/features/cart/presentation/bloc/payment_cubit/payment_cubit.dart';
import 'package:food_hub/features/cart/presentation/page/map.dart';
import 'package:food_hub/features/favorite/presentation/page/favorite.dart';
import 'package:food_hub/features/foods%20list/presentation/page/list_of_foods.dart';
import 'package:food_hub/features/home/presentation/home.dart';
import 'package:food_hub/features/home/presentation/page/detail_page.dart';
import 'package:food_hub/features/onboarding/presentation/onboarding_screen.dart';
import 'package:food_hub/features/order/presentation/pages/order_detail.dart';
import 'package:food_hub/features/search/presentation/search.dart';
import 'package:food_hub/features/setting/presentation/page/setting.dart';
import 'package:food_hub/firebase_options.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = StripeKey.stripePublishableKey;
  await initializedDependency();

  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthGate();
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignupPage();
      },
    ),
    GoRoute(
      path: '/search',
      builder: (BuildContext context, GoRouterState state) {
        return SearchScreen();
      },
    ),
    GoRoute(
      path: '/forgetpassword',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgetPasswordPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
    ),
    GoRoute(
      path: '/itemdetail',
      builder: (BuildContext context, GoRouterState state) {
        final item = state.extra as QueryDocumentSnapshot<Map<String, dynamic>>;
        return ItemDetail(item: item);
      },
    ),
    GoRoute(
      path: '/map',
      builder: (BuildContext context, GoRouterState state) {
        final location = state.extra as Position;
        return MyMapp(
          position: location,
        );
      },
    ),
    GoRoute(
      path: '/order_detail',
      builder: (BuildContext context, GoRouterState state) {
        final item = state.extra as Map<String, dynamic>;
        return OrderDetail(
          orderData: item,
        );
      },
    ),
    GoRoute(
      path: '/setting',
      builder: (BuildContext context, GoRouterState state) {
        return const Setting();
      },
    ),
    GoRoute(
      path: '/favorite',
      builder: (BuildContext context, GoRouterState state) {
        return const FavoriteScreen();
      },
    ),
    GoRoute(
      path: '/category',
      builder: (BuildContext context, GoRouterState state) {
        final category = state.extra as String;
        return ListOfFoods(
          category: category,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PaymentCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, theme) {
          return MaterialApp.router(
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            themeMode: theme,
            theme: lightMode,
            darkTheme: darkMode,
          );
        },
      ),
    );
  }
}
