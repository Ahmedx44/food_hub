import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/domain/usecase/remove_item.dart';
import 'package:food_hub/service_locator.dart';

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
    print(widget.item.price);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                              print(widget.item.itemLeft.toString());
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
                  const SizedBox(height: 8),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      final result =
                          await sl<RemoveItem>().call(widget.item.name);

                      result.fold((ifLeft) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                            content: Text(ifLeft)));
                      }, (ifRight) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                            content: Text(ifRight.toString())));
                      });
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
