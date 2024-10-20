import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String location;
  final Widget widget; // The widget you want to display in the app bar

  const MyAppBar({
    super.key,
    required this.name,
    required this.location,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.03, // Increase space to bring text lower
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10), // Adjust margin for better positioning
                      child: Text(
                        'Hello $name',
                        style: TextStyle(
                            fontSize: 15, // Slightly larger text
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        location,
                        style: TextStyle(
                            fontSize: 15, // Slightly larger text
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                  ],
                ),
                widget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight); // Set the preferred height for the app bar
}
