import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/service_locator.dart';

import '../../domain/usecase/add_to_cart_usecase.dart';

class Items extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> item;
  const Items({super.key, required this.item});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: double.infinity,
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: widget.item['name'],
                child: ExtendedImage.network(
                  height: 80,
                  cache: true,
                  widget.item['image_url'],
                ),
              ),
            ),
            Text(
              widget.item['name'],
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
                  rating: widget.item['rating'],
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.item['price']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity < widget.item['item left']) {
                              quantity = quantity + 1;
                            }
                          });
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary),
                          child: const Icon(
                            Icons.add,
                          ),
                        )),
                    Text(quantity.toString()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity = quantity - 1;
                            }
                          });
                        },
                        icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.secondary),
                            child: const Icon(Icons.remove))),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            GestureDetector(
              onTap: () async {
                try {
                  double totalPrice = widget.item['price'] * quantity;

                  final result = await sl<AddToCartUsecase>().call(CartModel(
                    id: widget.item.id,
                    quantity: quantity.toString(),
                    category: widget.item['category'],
                    description: widget.item['description'],
                    imageUrl: widget.item['image_url'],
                    itemLeft: widget.item['item left'].toString(),
                    name: widget.item['name'],
                    price: totalPrice,
                    rating: widget.item['rating']
                        .toString(), // Ensure this is a String
                  ));

                  result.fold((ifLeft) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red, content: Text(ifLeft)));
                  }, (ifRight) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.green,
                        content: Text(ifRight)));
                  });
                } catch (error, stackTrace) {
                  debugPrint(
                      'Error adding to cart: $error\nStack trace: $stackTrace');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
