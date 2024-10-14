import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/core/assets/app_vector.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnBoardingSlider(
        totalPage: 2,
        headerBackgroundColor: Colors.white,
        background: [
          SvgPicture.asset('assets/vector/delive.png'),
          SvgPicture.asset('assets/vector/enjoying.png'),
        ],
        speed: 1.8,
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        finishButtonText: 'Register',
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SvgPicture.asset(AppVector.delivery),
                Text(
                  'Fast and Reliable Delivery',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Image.asset(AppImage.enjoy),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                ),
                const Text(
                  'Wide Selection of Dishes',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
