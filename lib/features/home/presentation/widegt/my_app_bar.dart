import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/core/common/bloc/profile_bloc/profile_cubit.dart';
import 'package:food_hub/core/common/bloc/profile_bloc/profile_state.dart'; // For BackdropFilter

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String location;

  const MyAppBar({
    super.key,
    required this.name,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Hello $name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, right: 10),
                  child: BlocProvider(
                    create: (context) => ProfileCubit()..getProfile(),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileStateLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is ProfileStateLoaded) {
                          return ExtendedImage.network(
                            state.profileImageUrl.isEmpty
                                ? AppImage.apple
                                : state.profileImageUrl,
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            shape: BoxShape.circle,
                          );
                        } else if (state is ProfileStateError) {
                          return const Icon(Icons.error);
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
