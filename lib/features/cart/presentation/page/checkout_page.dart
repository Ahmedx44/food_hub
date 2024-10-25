import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/presentation/page/ordeR_confirm_page.dart';
import 'package:food_hub/features/cart/presentation/page/shipping_page.dart';
import 'package:food_hub/features/cart/presentation/page/success_page.dart';

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
      ShippingPage(
        cartItems: widget.cartItems,
        totalPrice: widget.totalPrice,
        onNext: goToNextStep,
      ),
      SuccessPage()
    ];
  }

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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Center(
                child: Icon(Icons.keyboard_double_arrow_down_outlined)),
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
              enableStepTapping: false,
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
              child: _pages[_activeStep],
            ),
          ],
        ),
      ),
    );
  }
}
