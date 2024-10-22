import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/presentation/page/ordeR_confirm_page.dart';
import 'package:food_hub/features/cart/presentation/page/payment_page.dart';
import 'package:food_hub/features/cart/presentation/page/shipping_page.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CheckoutPage extends StatefulWidget {
  final double totalPrice;
  final List<InCartModel> cartItems;

  const CheckoutPage(
      {super.key, required this.totalPrice, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _activeStep = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      OrderConfirmPage(
        cartItems: widget.cartItems,
        totalPrice: widget.totalPrice,
        onNext: goToNextStep,
      ),
      ShippingPage(),
      PaymentPage(),
    ];
  }

  // Get current location

  // Function to move to the next step
  void goToNextStep() {
    if (_activeStep < _pages.length - 1) {
      setState(() {
        _activeStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Checkout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          EasyStepper(
            fitWidth: true,
            activeStep: _activeStep,
            steps: const [
              EasyStep(
                icon: Icon(Icons.food_bank_rounded, size: 24),
                title: 'Food',
              ),
              EasyStep(
                icon: Icon(Icons.payment, size: 24),
                title: 'Payment & Address',
              ),
              EasyStep(
                icon: Icon(Icons.check_circle, size: 24),
                title: 'Ordered',
              ),
            ],
            onStepReached: (index) {
              setState(() {
                _activeStep = index;
              });
            },
          ),
          Expanded(
            child: _pages[
                _activeStep], // Display the active page based on the step
          ),
        ],
      ),
    );
  }
}




// Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.tertiary,
//       body: Container(
//         padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Checkout',
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.01,
//             ),
//             const Divider(),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.01,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     place != null && place!.isNotEmpty
//                         ? '${place![0].country}, ${place![0].administrativeArea}, ${place![0].locality}'
//                         : 'Fetching location...', // Loading message while fetching placemark
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 13),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (location != null) {
//                       context.push('/map', extra: location);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Location not available yet')),
//                       );
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Choose Your Location',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );