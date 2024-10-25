import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/domain/usecase/remove_item.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class CartItemTile extends StatefulWidget {
  final InCartModel item;
  final Function(String) onUpdate;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onUpdate,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = int.parse(widget.item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    final total_price = widget.item.price;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onTertiary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.outlineVariant,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExtendedImage.network(
                    widget.item.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitWidth,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity <
                                    int.parse(widget.item.itemLeft)) {
                                  quantity++;
                                  widget.onUpdate(quantity.toString());
                                }
                              });
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                  widget.onUpdate(quantity.toString());
                                }
                              });
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      // Show confirmation dialog
                      bool? result = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20.0,
                                  sigmaY: 20.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Remove from cart?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).pop(true);
                                              final response =
                                                  await sl<RemoveItem>()
                                                      .call(widget.item.name);
                                              response.fold((ifLeft) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(ifLeft)));
                                              }, (ifRight) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(ifRight
                                                            .toString())));
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.red),
                                              child: Center(
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              context.pop();
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.red),
                                              child: Center(
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                  Text(
                    total_price.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
