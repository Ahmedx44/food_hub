import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState {}

class HomeStateIntitial extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateLoaded extends HomeState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> result;

  HomeStateLoaded({required this.result});
}

class HomeStateLoadError extends HomeState {
  final String error;

  HomeStateLoadError({required this.error});
}
