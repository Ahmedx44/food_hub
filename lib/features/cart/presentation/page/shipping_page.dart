import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/data/model/payment_model.dart';
import 'package:food_hub/features/cart/domain/usecase/make_payment_usecase.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class ShippingPage extends StatefulWidget {
  final double totalPrice;
  final List<InCartModel> cartItems;
  final VoidCallback onNext;

  const ShippingPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.onNext,
  });

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  Position? location;
  List<Placemark>? place;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _additionalInfoController =
      TextEditingController();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Section
            _buildLocationSection(),
            const SizedBox(height: 20),
            // Additional Information Input
            _buildAdditionalInfoInput(),
            const SizedBox(height: 20),
            // Pay Button
            _buildPayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? _buildErrorSection()
              : _buildLocationInfo(),
    );
  }

  Widget _buildErrorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: getLocation,
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          place != null && place!.isNotEmpty
              ? '${place![0].locality}, ${place![0].administrativeArea}, ${place![0].country}'
              : 'Fetching location...',
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            if (location != null) {
              final updatedLocation =
                  await context.push('/map', extra: location);
              if (updatedLocation != null && updatedLocation is LatLng) {
                setState(() {
                  location = Position(
                    headingAccuracy: 1.0,
                    altitudeAccuracy: 1.0,
                    latitude: updatedLocation.latitude,
                    longitude: updatedLocation.longitude,
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location not available yet')),
              );
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Choose Your Location',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information for Delivery',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null // Disable the button tap if loading
          : () async {
              final result = await sl<MakePaymentUsecase>().call(
                PaymentModel(amount: widget.totalPrice, currency: 'usd'),
              );

              result.fold(
                (error) => showToast(
                  error,
                  backgroundColor: Colors.redAccent,
                  context: context,
                  animation: StyledToastAnimation.slideToTop,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.top,
                  animDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 4),
                  curve: Curves.easeInOut,
                ),
                (success) => showToast(
                  success,
                  backgroundColor: Colors.green,
                  context: context,
                  animation: StyledToastAnimation.slideToTop,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.top,
                  animDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 4),
                  curve: Curves.easeInOut,
                ),
              );
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLoading
              ? Colors.grey
              : Theme.of(context).colorScheme.primary, // Grey when loading
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Pay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLoading
                  ? Colors.black26
                  : Colors.white, // Text color changes accordingly
            ),
          ),
        ),
      ),
    );
  }
}
