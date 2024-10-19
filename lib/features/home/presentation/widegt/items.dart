import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Items extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> item;
  const Items({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: item['name'],
                child: ExtendedImage.network(
                  height: 100,
                  cache: true,
                  item['image_url'],
                ),
              ),
            ),
            Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text(
                  'Rating:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RatingBarIndicator(
                  itemSize: 13,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  direction: Axis.horizontal,
                  rating: item['rating'],
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.001,
            ),
            Row(
              children: [
                const Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  item['price'].toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
