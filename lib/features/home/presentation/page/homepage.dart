import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/features/home/domain/usecase/get_item_usecase.dart';
import 'package:food_hub/features/home/domain/usecase/get_location_usecase.dart';
import 'package:food_hub/features/home/presentation/bloc/home_cubit.dart';
import 'package:food_hub/features/home/presentation/bloc/home_state.dart';
import 'package:food_hub/features/home/presentation/widegt/custom_Card.dart';
import 'package:food_hub/features/home/presentation/widegt/item_skeleton.dart';
import 'package:food_hub/features/home/presentation/widegt/items.dart';
import 'package:food_hub/features/home/presentation/widegt/mini_card.dart';
import 'package:food_hub/features/home/presentation/widegt/my_app_bar.dart';
import 'package:food_hub/features/search/presentation/search.dart';
import 'package:food_hub/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
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
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        setState(() {
          location = '${placemarks[0].country}, '
              '${placemarks[0].administrativeArea}, '
              '${placemarks[0].locality}';
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
    final user = FirebaseAuth.instance.currentUser!.displayName;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;

    return BlocProvider(
      create: (context) => HomeCubit(sl<GetItemUsecase>())..getPopularItem(),
      child: Scaffold(
        appBar: MyAppBar(
          name: user.toString(),
          location: location.toString(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _buildSearchRow(context),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildCarouselSection(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _buildSectionHeader(
                    title: 'Our Cuisines',
                    onSeeAll: () {},
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.3,
                  child: _buildCuisinesList(),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _buildSectionHeader(
                    title: 'Popular',
                    onSeeAll: () {},
                  ),
                ),
                _buildPopularItemsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            ),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for food',
                  fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        GestureDetector(
          onTap: () => FirebaseAuth.instance.signOut(),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Icon(
              Icons.tune,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselSection() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 170.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
          items: [
            CustomerCard(
              action: 'Browse',
              title: 'New here?',
              image: AppImage.enjoy,
              text: 'Browse our exclusive offer with amazing prices',
            ),
            CustomerCard(
              action: 'Browse',
              title: 'Explore More!',
              image: AppImage.enjoy,
              text: 'Browse our exclusive offer with amazing prices',
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
      onDotClicked: (index) => _carouselController.animateToPage(index),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCuisinesList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildCuisineCard(
          image:
              'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(12).png?alt=media&token=4e402e09-1bc6-4f2e-bf49-9f5549d92170',
          name: 'Burger',
          category: 'Burgers',
        ),
        _buildCuisineCard(
          image:
              'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(13).png?alt=media&token=40af9837-6eb9-4214-bee2-89cce5351ec7',
          name: 'Pizza',
          category: 'pizza',
        ),
        _buildCuisineCard(
          image:
              'https://firebasestorage.googleapis.com/v0/b/food-hub-db057.appspot.com/o/food%20image%2Fpngwing.com(14).png?alt=media&token=69938f98-2fc8-48ab-97fc-e50198accf77',
          name: 'Pasta',
          category: 'Pasta',
        ),
      ],
    );
  }

  Widget _buildCuisineCard({
    required String image,
    required String name,
    required String category,
  }) {
    return GestureDetector(
      onTap: () => context.push('/category', extra: category),
      child: MiniCards(image: image, name: name),
    );
  }

  Widget _buildPopularItemsGrid() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeStateLoading) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => const ShimmerSkeleton(),
          );
        } else if (state is HomeStateLoaded) {
          return StreamBuilder(
            stream: state.result,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.75,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final item = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () => context.push('/itemdetail', extra: item),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 200,
                          child: Items(item: item),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No items found'));
                }
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to load data'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is HomeStateLoadError) {
          return const Center(child: Text('Failed to load popular items'));
        }
        return Container();
      },
    );
  }
}
