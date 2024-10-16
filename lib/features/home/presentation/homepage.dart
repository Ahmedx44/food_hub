import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position position;
  String? location = '';

  Future<void> checkLocation() async {
    final result = await sl<GetLocationUsecase>().call();
    result.fold(
      (failureMessage) {
        showToast(
          failureMessage,
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
      },
      (currentPosition) async {
        position = currentPosition;

        // Get location information from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        // Construct a location string
        String newLocation =
            '${placemarks[0].country}, ${placemarks[0].administrativeArea}, ${placemarks[0].locality}';

        setState(() {
          location = newLocation;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkLocation();
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Text(location.toString()),
        ],
      ),
    ));
  }
}
