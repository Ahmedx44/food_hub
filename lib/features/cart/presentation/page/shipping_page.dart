import 'package:flutter/material.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/service_locator.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({
    super.key,
  });

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  Position? location;
  List<Placemark>? place;
  bool isLoading = true;
  String? errorMessage; // To store error messages

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await sl<GetLocationUsecase>().call();
    result.fold((ifLeft) {
      // If location fetching fails, set an error message
      setState(() {
        errorMessage = "Failed to get location. Please try again.";
        isLoading = false;
      });
    }, (ifRight) {
      setState(() {
        location = ifRight;
      });
      getPlacemark();
    });
  }

  Future<void> getPlacemark() async {
    if (location != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location!.latitude, location!.longitude);
        setState(() {
          place = placemarks;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = "Failed to get placemark. Please try again.";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Information'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show a loading spinner while fetching data
            : errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: getLocation, // Retry button
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on,
                          size: 48, color: Colors.blue),
                      const SizedBox(height: 16),
                      Text(
                        place == null || place!.isEmpty
                            ? 'No location available'
                            : place![0].administrativeArea ?? 'Unknown area',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        place != null && place!.isNotEmpty
                            ? place![0].locality ?? 'Unknown city'
                            : '',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
      ),
    );
  }
}
