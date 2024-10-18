import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class ItemDetail extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> item;
  const ItemDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.secondary),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  )
                ],
              ),
              Center(
                child: Hero(
                  tag: item['name'],
                  child: ExtendedImage.network(
                    height: 300,
                    cache: true,
                    item['image_url'],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        itemSize: 15,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        direction: Axis.horizontal,
                        rating: item['rating'],
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                      ),
                      Text(
                        item['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  children: [
                    const TextSpan(text: 'Price: '),
                    TextSpan(
                      text: item['price'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
