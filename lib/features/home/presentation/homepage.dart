import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/features/home/presentation/widegt/custom_Card.dart';
import 'package:food_hub/features/home/presentation/widegt/mini_card.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import for the smooth indicator

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position position;
  String? location = '';
  int _current = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

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
    checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello ${FirebaseAuth.instance.currentUser!.displayName}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        location.toString(),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_none_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search for food',
                        fillColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary),
                    child: Icon(
                      Icons.tune,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _carousel(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our Couisines',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text('See All',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.primary))
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  MiniCards(
                      image:
                          'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(12).png?alt=media&token=4e402e09-1bc6-4f2e-bf49-9f5549d92170',
                      name: 'Burger'),
                  MiniCards(
                      image:
                          'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(12).png?alt=media&token=4e402e09-1bc6-4f2e-bf49-9f5549d92170',
                      name: 'Burger'),
                  MiniCards(
                      image:
                          'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(12).png?alt=media&token=4e402e09-1bc6-4f2e-bf49-9f5549d92170',
                      name: 'Burger')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _carousel() {
    return Column(
      children: [
        CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: 170.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: [
              CustomerCard(
                  action: 'Browse',
                  title: 'New here?',
                  image: AppImage.enjoy,
                  text: 'Browser our exclusive offer with amaying perice'),
              CustomerCard(
                  action: 'Browse',
                  title: 'New here?',
                  image: AppImage.enjoy,
                  text: 'Browser our exclusive offer with amaying perice')
            ]),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: _current,
      count: 2,
      effect: WormEffect(
        dotHeight: 10,
        dotWidth: 10,
        activeDotColor: Theme.of(context).colorScheme.primary,
        dotColor: Colors.grey,
      ),
      onDotClicked: (index) {
        _carouselController.animateToPage(index);
      },
    );
  }
}
