import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

import 'package:food_hub/features/cart/presentation/page/cart.dart';
import 'package:food_hub/features/home/presentation/page/homepage.dart';
import 'package:food_hub/features/order/presentation/pages/order.dart';
import 'package:food_hub/features/profile/presentation/profile.dart';
import 'package:food_hub/features/search/presentation/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeScreen(),
      const SearchScreen(),
      const CartScreen(),
      const OrderScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildGlassMorphismNavigationBar(context),
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
    );
  }

  Widget _buildGlassMorphismNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.1), // Transparent white background

              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.1,
              ),
            ),
            child: BottomBarFloating(
              items: const [
                TabItem(icon: CupertinoIcons.home, title: 'Home'),
                TabItem(icon: CupertinoIcons.search, title: 'Search'),
                TabItem(icon: CupertinoIcons.cart, title: 'Cart'),
                TabItem(icon: CupertinoIcons.doc_on_clipboard, title: 'Order'),
                TabItem(icon: CupertinoIcons.person, title: 'Profile'),
              ],
              backgroundColor:
                  Colors.transparent, // Transparent to maintain glass effect
              color: Theme.of(context).colorScheme.onPrimary,
              colorSelected: Theme.of(context).colorScheme.primary,
              indexSelected: pageIndex,
              paddingVertical: 24,
              onTap: (int index) => setState(() {
                pageIndex = index;
              }),
            ),
          ),
        ),
      ),
    );
  }
}
