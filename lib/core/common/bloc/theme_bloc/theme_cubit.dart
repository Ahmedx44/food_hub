import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void changeTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    return json['isDarkMode'] as bool ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Map<String, dynamic> toJson(ThemeMode state) {
    return {'isDarkMode': state == ThemeMode.dark};
  }
}
