import 'package:flutter/material.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';
import 'package:food_hub/features/cart/domain/usecase/make_payment_usecase.dart';

import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';

import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  Position? location;
  List<Placemark>? place;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _additionalInfoController =
      TextEditingController(); // Controller for the text field
  final TextEditingController _amountController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Location Fetching Section
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : errorMessage != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: getLocation,
                                child: const Text('Retry'),
                              ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        place != null && place!.isNotEmpty
                                            ? '${place![0].country}, ${place![0].administrativeArea}, ${place![0].locality}'
                                            : 'Fetching location...',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (location != null) {
                                          // Navigate to the map and wait for the updated location
                                          final updatedLocation =
                                              await context.push(
                                            '/map',
                                            extra: location,
                                          );
                                          if (updatedLocation != null &&
                                              updatedLocation is LatLng) {
                                            // Update the position with the new selected location
                                            setState(() {
                                              location = Position(
                                                headingAccuracy: 1.0,
                                                altitudeAccuracy: 1.0,
                                                latitude:
                                                    updatedLocation.latitude,
                                                longitude:
                                                    updatedLocation.longitude,
                                                timestamp: DateTime.now(),
                                                accuracy: 1.0,
                                                altitude: 0.0,
                                                heading: 0.0,
                                                speed: 0.0,
                                                speedAccuracy: 0.0,
                                              );
                                            });
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Location not available yet')),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Choose Your Location',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Additional Information for Delivery',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _additionalInfoController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Provide any additional details (e.g., floor, landmark)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    final additionalInfo =
                                        _additionalInfoController.text;
                                    print('Additional Info: $additionalInfo');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
              const SizedBox(height: 20),
              // Payment UI Section
              GestureDetector(
                onTap: () async {
                  final result = await sl<MakePaymentUsecase>().call(
                      PaymentModel(
                          amount: 10,
                          currency: 'usd')); // Corrected 'uds' to 'usd'

                  result.fold(
                    (error) => print('Payment failed: $error'),
                    (success) => print('Payment successful: $success'),
                  );
                },
                child: const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
