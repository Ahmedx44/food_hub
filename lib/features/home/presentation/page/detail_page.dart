import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
import 'package:food_hub/features/home/domain/usecase/add_to_cart_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class ItemDetail extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> item;
  const ItemDetail({super.key, required this.item});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.secondary),
                      child: const Icon(Icons.favorite_border),
                    ),
                  )
                ],
              ),
              Center(
                child: Hero(
                  tag: widget.item['name'],
                  child: ExtendedImage.network(
                    height: 300,
                    cache: true,
                    widget.item['image_url'],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        widget.item['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  children: [
                    TextSpan(
                        text: 'Price: ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary)),
                    TextSpan(
                      text: widget.item['price'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(),
                child: Row(
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
              ),
              Text(
                softWrap: true,
                style: const TextStyle(wordSpacing: 0.5),
                textAlign: TextAlign.justify,
                widget.item['description'],
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    double totalPrice = widget.item['price'] * quantity;
                    final result = await sl<AddToCartUsecase>().call(CartModel(
                      quantity: quantity.toString(),
                      category: widget.item['category'],
                      description: widget.item['description'],
                      imageUrl: widget.item['image_url'],
                      itemLeft: widget.item['item left'].toString(),
                      name: widget.item['name'],
                      price: totalPrice,
                      rating: widget.item['rating'].toString(),
                    ));

                    result.fold((ifLeft) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(ifLeft)));
                    }, (ifRight) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(ifRight)));
                    });
                  } catch (error, stackTrace) {
                    debugPrint(
                        'Error adding to cart: $error\nStack trace: $stackTrace');
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
