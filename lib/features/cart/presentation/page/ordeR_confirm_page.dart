import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';

class OrderConfirmPage extends StatelessWidget {
  final double totalPrice;
  final List<InCartModel> cartItems;
  final VoidCallback onNext; // Add this to receive the callback

  const OrderConfirmPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.onNext, // Pass the callback in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ExtendedImage.network(
                      item.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Quantity: ${item.quantity}'),
                        Text('Price: \$${item.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Total Price: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    totalPrice.toStringAsFixed(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onNext,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary),
                  child: Text(
                    'Proceed to Shipping',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
