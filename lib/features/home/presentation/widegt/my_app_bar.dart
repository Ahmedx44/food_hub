import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/core/common/bloc/profile_bloc/profile_cubit.dart';
import 'package:food_hub/core/common/bloc/profile_bloc/profile_state.dart';

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
      backgroundColor: Colors.transparent, // Make AppBar transparent
      flexibleSpace: ClipRRect(
        borderRadius:
            BorderRadius.circular(20), // Rounded corners for glass effect
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 20.0, sigmaY: 20.0), // Increased blur for glassmorphism
          child: Container(
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.2), // Add opacity for glass effect
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    Colors.white.withOpacity(0.3), // Slight border for outline
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 9,
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
