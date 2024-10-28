import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryState {}

class CategoryStateInitial extends CategoryState {}

class CategoryStateLoaded extends CategoryState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> result;

  CategoryStateLoaded({required this.result});
}

class CategoryStateLoading extends CategoryState {}

class CategoryStateError extends CategoryState {
  final String error;

  CategoryStateError({required this.error});
}
