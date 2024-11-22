import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:food_hub/features/profile/presentation/bloc/user_data_cubit.dart';
import 'package:food_hub/features/profile/presentation/bloc/user_data_state.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocProvider(
      create: (context) =>
          UserDataCubit(sl<GetUserInfoUsecase>())..getUserInfo(),
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: BlocBuilder<UserDataCubit, UserDataState>(
                builder: (context, state) {
                  if (state is UserDataStateLoading) {
                    return ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ExtendedImage.network(
                          '',
                          cache: true,
                          loadStateChanged: (state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return const Center(
                                    child: CircularProgressIndicator());
                              case LoadState.failed:
                                return Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                );
                              case LoadState.completed:
                                return ExtendedRawImage(
                                  image: state.extendedImageInfo?.image,
                                  fit: BoxFit.cover,
                                );
                            }
                          },
                        ),
                      ),
                    );
                  } else if (state is UserDataStateError) {
                    return ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ExtendedImage.network(
                          '',
                          cache: true,
                          loadStateChanged: (state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return const Center(
                                    child: CircularProgressIndicator());
                              case LoadState.failed:
                                return Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                );
                              case LoadState.completed:
                                return ExtendedRawImage(
                                  image: state.extendedImageInfo?.image,
                                  fit: BoxFit.cover,
                                );
                            }
                          },
                        ),
                      ),
                    );
                  } else if (state is UserDataStateLoaded) {
                    return StreamBuilder(
                      stream: state.result,
                      builder: (context, snapshot) {
                        return ClipOval(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ExtendedImage.network(
                              snapshot.data!['imageUrl'],
                              cache: true,
                              loadStateChanged: (state) {
                                switch (state.extendedImageLoadState) {
                                  case LoadState.loading:
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  case LoadState.failed:
                                    return Center(
                                      child: Icon(
                                        Icons.error,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    );
                                  case LoadState.completed:
                                    return ExtendedRawImage(
                                      image: state.extendedImageInfo?.image,
                                      fit: BoxFit.cover,
                                    );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else
                    return Container();
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Center(
                  child: Text(
                    user!.displayName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/setting');
                    },
                    child: const ListTile(
                      leading: Icon(Icons.settings),
                      title: Text(
                        'Setting',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        weight: 2,
                      ),
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.card_giftcard),
                    title: Text(
                      'Inviate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      weight: 2,
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      context.push('/favorite');
                    },
                    child: const ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text(
                        'Favorite',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        weight: 2,
                      ),
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.help),
                    title: Text(
                      'Help Center',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      weight: 2,
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.contact_mail),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      weight: 2,
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      context.go('/login');
                      FirebaseAuth.instance.signOut();
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        weight: 2,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
