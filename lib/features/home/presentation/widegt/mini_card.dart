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
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary),
      child: Column(
        children: [
          ExtendedImage.network(height: 180, cache: true, image),
          Text(name)
        ],
      ),
    );
  }
}
