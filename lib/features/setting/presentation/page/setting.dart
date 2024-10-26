import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/core/common/bloc/theme_bloc/theme_cubit.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: ListTile(
            title: const Text(
              'DARK MODE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                context.read<ThemeCubit>().changeTheme();
              },
            ),
          ),
        ),
      ),
    );
  }
}
