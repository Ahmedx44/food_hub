import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_state.dart';
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
      create: (context) {
        final cartCubit = CartCubit(sl<GetAllCart>());
        cartCubit.getCart(); // Trigger the data fetch when the cubit is created
        return cartCubit;
      },
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
              if (state.cartItem.isEmpty) {
                return const Center(child: Text("Your cart is empty"));
              }

              return ListView.builder(
                itemCount: state.cartItem.length,
                itemBuilder: (context, index) {
                  final item = state.cartItem[index];
                  return CartItemTile(
                      item: item,
                      onUpdate: (updatedQuantity) {
                        setState(() {
                          item.quantity = updatedQuantity.toString();
                        });
                      });
                },
              );
            } else if (state is CartStateError) {
              return const Center(child: Text("Error: Failed to load cart"));
            }

            return const Center(child: Text("No data available"));
          },
        ),
      ),
    );
  }
}
