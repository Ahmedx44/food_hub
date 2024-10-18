import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/features/home/presentation/bloc/home_cubit.dart';
import 'package:food_hub/features/home/presentation/widegt/custom_Card.dart';
import 'package:food_hub/features/home/presentation/widegt/mini_card.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  void addFoodDataToFirestore() {
    // Create an instance of Firestore
    final firestore = FirebaseFirestore.instance;

    // The JSON-like Map
    final foodData = {
      "categories": [
        {
          "id": 1,
          "name": "Pizza",
          "items": [
            {
              "id": 101,
              "name": "Margherita",
              "description":
                  "Classic pizza topped with fresh mozzarella, tomatoes, and basil.",
              "price": 8.99,
              "image_url": "https://example.com/images/margherita.png",
              "rating": 4.5,
              "category": "Pizza"
            },
            {
              "id": 102,
              "name": "Pepperoni",
              "description":
                  "Spicy pepperoni with tomato sauce and mozzarella.",
              "price": 9.99,
              "image_url": "https://example.com/images/pepperoni.png",
              "rating": 4.7,
              "category": "Pizza"
            }
          ]
        },
        {
          "id": 2,
          "name": "Burgers",
          "items": [
            {
              "id": 201,
              "name": "Cheeseburger",
              "description":
                  "Beef patty with cheddar cheese, lettuce, tomato, and pickles.",
              "price": 7.49,
              "image_url": "https://example.com/images/cheeseburger.png",
              "rating": 4.8,
              "category": "Burgers"
            },
            {
              "id": 202,
              "name": "Chicken Burger",
              "description":
                  "Grilled chicken breast with lettuce, tomato, and mayo.",
              "price": 6.99,
              "image_url": "https://example.com/images/chicken_burger.png",
              "rating": 4.6,
              "category": "Burgers"
            }
          ]
        },
        {
          "id": 3,
          "name": "Pasta",
          "items": [
            {
              "id": 301,
              "name": "Spaghetti Bolognese",
              "description":
                  "Traditional Italian pasta with beef bolognese sauce.",
              "price": 12.99,
              "image_url": "https://example.com/images/spaghetti_bolognese.png",
              "rating": 4.8,
              "category": "Pasta"
            },
            {
              "id": 302,
              "name": "Penne Alfredo",
              "description":
                  "Creamy Alfredo sauce with penne pasta and grilled chicken.",
              "price": 11.99,
              "image_url": "https://example.com/images/penne_alfredo.png",
              "rating": 4.7,
              "category": "Pasta"
            },
            {
              "id": 303,
              "name": "Pesto Pasta",
              "description":
                  "Penne pasta with homemade basil pesto and Parmesan.",
              "price": 10.49,
              "image_url": "https://example.com/images/pesto_pasta.png",
              "rating": 4.6,
              "category": "Pasta"
            }
          ]
        },
        {
          "id": 4,
          "name": "Sushi",
          "items": [
            {
              "id": 401,
              "name": "California Roll",
              "description":
                  "Crab, avocado, and cucumber rolled in seaweed and rice.",
              "price": 8.99,
              "image_url": "https://example.com/images/california_roll.png",
              "rating": 4.8,
              "category": "Sushi"
            },
            {
              "id": 402,
              "name": "Spicy Tuna Roll",
              "description": "Fresh tuna with spicy mayo and sesame seeds.",
              "price": 9.99,
              "image_url": "https://example.com/images/spicy_tuna_roll.png",
              "rating": 4.9,
              "category": "Sushi"
            },
            {
              "id": 403,
              "name": "Salmon Nigiri",
              "description": "Slices of salmon over seasoned rice.",
              "price": 7.99,
              "image_url": "https://example.com/images/salmon_nigiri.png",
              "rating": 4.7,
              "category": "Sushi"
            }
          ]
        },
        {
          "id": 5,
          "name": "Desserts",
          "items": [
            {
              "id": 501,
              "name": "Chocolate Cake",
              "description":
                  "Rich chocolate cake with layers of chocolate frosting.",
              "price": 4.99,
              "image_url": "https://example.com/images/chocolate_cake.png",
              "rating": 4.9,
              "category": "Desserts"
            },
            {
              "id": 502,
              "name": "Ice Cream Sundae",
              "description":
                  "Vanilla ice cream with chocolate syrup, nuts, and a cherry.",
              "price": 3.99,
              "image_url": "https://example.com/images/ice_cream_sundae.png",
              "rating": 4.6,
              "category": "Desserts"
            },
            {
              "id": 503,
              "name": "Cheesecake",
              "description":
                  "Classic New York-style cheesecake with a graham cracker crust.",
              "price": 5.49,
              "image_url": "https://example.com/images/cheesecake.png",
              "rating": 4.8,
              "category": "Desserts"
            }
          ]
        },
        {
          "id": 6,
          "name": "Salads",
          "items": [
            {
              "id": 601,
              "name": "Caesar Salad",
              "description":
                  "Crisp romaine lettuce, Parmesan cheese, croutons, and Caesar dressing.",
              "price": 7.99,
              "image_url": "https://example.com/images/caesar_salad.png",
              "rating": 4.5,
              "category": "Salads"
            },
            {
              "id": 602,
              "name": "Greek Salad",
              "description":
                  "Mixed greens with feta cheese, Kalamata olives, tomatoes, and cucumbers.",
              "price": 6.99,
              "image_url": "https://example.com/images/greek_salad.png",
              "rating": 4.6,
              "category": "Salads"
            },
            {
              "id": 603,
              "name": "Cobb Salad",
              "description":
                  "Grilled chicken, avocado, bacon, egg, tomatoes, and blue cheese over mixed greens.",
              "price": 9.49,
              "image_url": "https://example.com/images/cobb_salad.png",
              "rating": 4.7,
              "category": "Salads"
            }
          ]
        },
        {
          "id": 7,
          "name": "Drinks",
          "items": [
            {
              "id": 701,
              "name": "Coca Cola",
              "description": "Chilled bottle of classic Coca Cola.",
              "price": 1.99,
              "image_url": "https://example.com/images/coca_cola.png",
              "rating": 4.8,
              "category": "Drinks"
            },
            {
              "id": 702,
              "name": "Lemonade",
              "description": "Freshly squeezed lemonade with a hint of mint.",
              "price": 2.49,
              "image_url": "https://example.com/images/lemonade.png",
              "rating": 4.6,
              "category": "Drinks"
            },
            {
              "id": 703,
              "name": "Iced Tea",
              "description": "Sweetened iced tea with lemon.",
              "price": 2.29,
              "image_url": "https://example.com/images/iced_tea.png",
              "rating": 4.5,
              "category": "Drinks"
            }
          ]
        },
        {
          "id": 8,
          "name": "Breakfast",
          "items": [
            {
              "id": 801,
              "name": "Pancakes",
              "description":
                  "Fluffy pancakes served with maple syrup and butter.",
              "price": 5.99,
              "image_url": "https://example.com/images/pancakes.png",
              "rating": 4.9,
              "category": "Breakfast"
            },
            {
              "id": 802,
              "name": "Omelette",
              "description":
                  "Three-egg omelette with cheese, mushrooms, and spinach.",
              "price": 6.99,
              "image_url": "https://example.com/images/omelette.png",
              "rating": 4.7,
              "category": "Breakfast"
            },
            {
              "id": 803,
              "name": "French Toast",
              "description":
                  "Cinnamon French toast served with powdered sugar and syrup.",
              "price": 5.49,
              "image_url": "https://example.com/images/french_toast.png",
              "rating": 4.6,
              "category": "Breakfast"
            }
          ]
        },
        {
          "id": 9,
          "name": "Seafood",
          "items": [
            {
              "id": 901,
              "name": "Grilled Salmon",
              "description": "Grilled salmon fillet with lemon and herbs.",
              "price": 14.99,
              "image_url": "https://example.com/images/grilled_salmon.png",
              "rating": 4.8,
              "category": "Seafood"
            },
            {
              "id": 902,
              "name": "Shrimp Scampi",
              "description":
                  "Shrimp sautéed in garlic butter and served with pasta.",
              "price": 15.49,
              "image_url": "https://example.com/images/shrimp_scampi.png",
              "rating": 4.9,
              "category": "Seafood"
            },
            {
              "id": 903,
              "name": "Fish Tacos",
              "description":
                  "Soft tacos filled with grilled fish, cabbage, and salsa.",
              "price": 12.99,
              "image_url": "https://example.com/images/fish_tacos.png",
              "rating": 4.6,
              "category": "Seafood"
            }
          ]
        },
        {
          "id": 10,
          "name": "Appetizers",
          "items": [
            {
              "id": 1001,
              "name": "Mozzarella Sticks",
              "description":
                  "Crispy fried mozzarella sticks served with marinara sauce.",
              "price": 5.99,
              "image_url": "https://example.com/images/mozzarella_sticks.png",
              "rating": 4.6,
              "category": "Appetizers"
            },
            {
              "id": 1002,
              "name": "Chicken Wings",
              "description":
                  "Buffalo chicken wings served with blue cheese dressing.",
              "price": 8.49,
              "image_url": "https://example.com/images/chicken_wings.png",
              "rating": 4.7,
              "category": "Appetizers"
            },
            {
              "id": 1003,
              "name": "Nachos",
              "description":
                  "Tortilla chips topped with cheese, jalapeños, and sour cream.",
              "price": 6.99,
              "image_url": "https://example.com/images/nachos.png",
              "rating": 4.5,
              "category": "Appetizers"
            }
          ]
        },
        {
          "id": 11,
          "name": "Sandwiches",
          "items": [
            {
              "id": 1101,
              "name": "Club Sandwich",
              "description":
                  "Turkey, bacon, lettuce, tomato, and mayo on toasted bread.",
              "price": 8.99,
              "image_url": "https://example.com/images/club_sandwich.png",
              "rating": 4.7,
              "category": "Sandwiches"
            },
            {
              "id": 1102,
              "name": "BLT Sandwich",
              "description":
                  "Bacon, lettuce, and tomato with mayo on toasted bread.",
              "price": 7.49,
              "image_url": "https://example.com/images/blt_sandwich.png",
              "rating": 4.6,
              "category": "Sandwiches"
            },
            {
              "id": 1103,
              "name": "Grilled Cheese",
              "description":
                  "Classic grilled cheese sandwich with cheddar cheese.",
              "price": 5.49,
              "image_url": "https://example.com/images/grilled_cheese.png",
              "rating": 4.5,
              "category": "Sandwiches"
            }
          ]
        }
      ]
    };

    // Add the data to Firestore
    firestore.collection("foods").add(foodData).then((_) {
      print("Data added successfully to Firestore");
    }).catchError((error) {
      print("Failed to add data to Firestore: $error");
    });
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
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  MiniCards(
                      image:
                          'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(12).png?alt=media&token=4e402e09-1bc6-4f2e-bf49-9f5549d92170',
                      name: 'Burger'),
                  MiniCards(
                    image:
                        'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(13).png?alt=media&token=40af9837-6eb9-4214-bee2-89cce5351ec7',
                    name: 'Pizza',
                  ),
                  MiniCards(
                    image:
                        'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(14).png?alt=media&token=69938f98-2fc8-48ab-97fc-e50198accf77',
                    name: 'Pasta',
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular',
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
            BlocProvider(
              create: (context) => HomeCubit(),
              child: Column(
                children: [],
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
