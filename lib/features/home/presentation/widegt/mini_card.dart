import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiniCards extends StatelessWidget {
  final String image;
  final String name;

  const MiniCards({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.03),
      height: 150,
      width: MediaQuery.of(context).size.width * 0.39,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onSecondaryContainer),
      child: Column(
        children: [
          ExtendedImage.network(
              height: MediaQuery.of(context).size.height * 0.2,
              cache: true,
              image),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          )
        ],
      ),
    );
  }
}
