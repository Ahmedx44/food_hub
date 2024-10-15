import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
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
        indexSelected: page,
        paddingVertical: 24,
        onTap: (int index) => setState(() {
          page = index;
        }),
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
