import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/foods%20list/domain/usecase/get_category_usecase.dart';
import 'package:food_hub/features/foods%20list/presentation/bloc/category_cubit.dart';
import 'package:food_hub/features/foods%20list/presentation/bloc/category_state.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class ListOfFoods extends StatefulWidget {
  final String category;
  const ListOfFoods({super.key, required this.category});

  @override
  State<ListOfFoods> createState() => _ListOfFoodsState();
}

class _ListOfFoodsState extends State<ListOfFoods>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryCubit(sl<GetCategoryUsecase>())..getCategory(widget.category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryStateError) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is CategoryStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CategoryStateLoaded) {
              return StreamBuilder(
                stream: state.result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No foods found.'));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final foodData = docs[index].data();

                      // Delay for each item based on its index
                      Future.delayed(Duration(milliseconds: index * 100), () {
                        if (mounted) {
                          _animationController.forward(
                              from: 0); // Reset and play animation
                        }
                      });

                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0), // Start from the right
                          end: Offset.zero, // End at the original position
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOut,
                        )),
                        child: GestureDetector(
                          onTap: () {
                            context.push('/itemdetail', extra: docs[index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.tertiary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExtendedImage.network(
                                  foodData['image_url'],
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  fit: BoxFit.fill,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foodData['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        foodData['description'] ?? '',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Price: \$${foodData['price'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${foodData['rating'] ?? 'N/A'}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'Available: ${foodData['item left'] ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
