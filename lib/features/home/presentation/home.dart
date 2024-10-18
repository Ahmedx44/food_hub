import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/features/cart/presentation/cart.dart';
import 'package:food_hub/features/home/presentation/page/homepage.dart';
import 'package:food_hub/features/order/presentation/order.dart';
import 'package:food_hub/features/profile/presentation/profile.dart';
import 'package:food_hub/features/search/presentation/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  Widget page = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    if (pageIndex == 0) {
      page = const HomeScreen();
    } else if (pageIndex == 1) {
      page = const SearchScreen();
    } else if (pageIndex == 2) {
      page = const CartScreen();
    } else if (pageIndex == 3) {
      page = const OrderScreen();
    } else if (pageIndex == 4) {
      page = const ProfileScreen();
    }
    return Scaffold(
        bottomNavigationBar: BottomBarFloating(
          items: const [
            TabItem(icon: CupertinoIcons.home, title: 'Home'),
            TabItem(icon: CupertinoIcons.search, title: 'Search'),
            TabItem(icon: CupertinoIcons.cart, title: 'Cart'),
            TabItem(icon: CupertinoIcons.doc_on_clipboard, title: 'Order'),
            TabItem(icon: CupertinoIcons.person, title: 'Profile'),
          ],
          backgroundColor: Theme.of(context).colorScheme.surface,
          color: Theme.of(context).colorScheme.onPrimary,
          colorSelected: Theme.of(context).colorScheme.primary,
          indexSelected: pageIndex,
          paddingVertical: 24,
          onTap: (int index) => setState(() {
            pageIndex = index;
          }),
        ),
        body: page);
  }
}
