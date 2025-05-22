import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/data/model/in_cart_model.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_state.dart';
import 'package:food_hub/features/cart/presentation/page/checkout_page.dart';
import 'package:food_hub/features/cart/presentation/widget/cart_item_tile.dart';
import 'package:food_hub/service_locator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(sl<GetAllCart>())..getCart(),
      child: Scaffold(
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartStateLoaded) {
              return StreamBuilder<List<InCartModel>>(
                stream: state.cartItem,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Your cart is empty"));
                  }

                  final cartItems = snapshot.data!;

                  double totalPrice = cartItems.fold(0.0, (sum, item) {
                    double quantity = double.tryParse(item.quantity) ??
                        1.0; // Default to 1 if parsing fails
                    return sum + (item.originalPrice * quantity);
                  });

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return CartItemTile(
                                  item: item,
                                  onUpdate: (updatedQuantity) {
                                    context.read<CartCubit>().updateQuantity(
                                          item.name,
                                          int.parse(updatedQuantity),
                                        );
                                  });
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        // Display Total Price
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Price:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${totalPrice.toStringAsFixed(2)}', // Format the total price
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),

                        GestureDetector(
                          onTap: () {
                            showBottomSheet(
                              enableDrag: true,
                              elevation: 0,
                              sheetAnimationStyle: AnimationStyle(
                                  curve: Curves.bounceInOut,
                                  duration: const Duration(milliseconds: 500)),
                              context: context,
                              builder: (context) {
                                return CheckoutPage(
                                  totalPrice: totalPrice,
                                  cartItems: cartItems,
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).colorScheme.primary),
                            child: Center(
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is CartStateError) {
              return Center(child: Text(state.error));
            }

            return const Center(child: Text("No data available"));
          },
        ),
      ),
    );
  }
}
