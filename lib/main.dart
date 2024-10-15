import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/core/theme/theme.dart';
import 'package:food_hub/features/auth/presentation/pages/auth_gate.dart';
import 'package:food_hub/features/auth/presentation/pages/forget_password_page.dart';
import 'package:food_hub/features/auth/presentation/pages/login.dart';
import 'package:food_hub/features/auth/presentation/pages/signup.dart';
import 'package:food_hub/features/home/presentation/home.dart';
import 'package:food_hub/features/onboarding/presentation/onboarding_screen.dart';
import 'package:food_hub/firebase_options.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
