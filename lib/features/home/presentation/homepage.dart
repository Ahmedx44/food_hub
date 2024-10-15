import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/features/home/data/repository/location_repositoy_impl.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position position;
  String message = '';

  checklocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? action = prefs.getString('location');
    if (action!.isEmpty) {
      final result = await sl<GetLocationUsecase>().call();
      result.fold((ifLeft) {
        showToast(
          ifLeft,
          backgroundColor: Colors.red,
          context: context,
          animation: StyledToastAnimation.slideToTop,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.top,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
        );
      }, (ifRight) {
        setState(() {
          position = ifRight;
        });
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    checklocation();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
