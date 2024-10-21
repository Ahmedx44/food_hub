import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_state.dart';
import 'package:food_hub/features/cart/presentation/widget/cart_item_tile.dart';
import 'package:food_hub/features/home/data/model/cart_model.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartStateLoaded) {
              return StreamBuilder<List<CartModel>>(
                stream: state.cartItem, // Listening to the stream
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

                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return CartItemTile(
                                item: item,
                                onUpdate: (updatedQuantity) {
                                  // Call the Cubit method to update quantity
                                  context.read<CartCubit>().updateQuantity(
                                      // item.id,
                                      // int.parse(updatedQuantity),
                                      );
                                });
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ),
                      ),
                    ],
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
