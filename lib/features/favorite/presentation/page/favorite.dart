import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/favorite/domain/usecase/get_user_favorite_usecase.dart';
import 'package:food_hub/features/favorite/presentation/bloc/favorite_cubit.dart';
import 'package:food_hub/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            FavoriteCubit(sl<GetUserFavoriteUsecase>())..getUserfavorite(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favorite',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FavoriteStateLoaded) {
                return StreamBuilder(
                    stream: state.result,
                    builder: (context, snapshot) {
                      final data = snapshot.data!.data();
                      final item = data!['items'];

                      return Container(
                        child: Expanded(
                            child: ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (context, index) {
                            final itemData = item[index];
                            return Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              child: Row(
                                children: [
                                  ExtendedImage.network(
                                      height: 80, width: 80, itemData['image']),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemData['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$${itemData['price']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        )),
                      );
                    });
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}
