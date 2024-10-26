import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/order/domain/usecase/get_user_orders.dart';
import 'package:food_hub/features/order/presentation/bloc/order_cubit.dart';
import 'package:food_hub/features/order/presentation/bloc/order_state.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderCubit(sl<GetUserOrdersUseCase>())..getUserOrder(),
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderStateError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is OrderStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderStateLoaded) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: state.result,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No orders found."));
                }

                final orders = snapshot.data!.docs;

                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final orderData = orders[index].data();

                          return GestureDetector(
                            onTap: () {
                              context.push('/order_detail', extra: orderData);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      'Order ID: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                    ),
                                    Text(
                                      '${orders[index].id}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                    )
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "Order Total: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                    ),
                                    Text(
                                      '\$${orderData['amount']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  ],
                                ),
                                trailing:
                                    Text("Status: ${orderData['orderStatus']}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
