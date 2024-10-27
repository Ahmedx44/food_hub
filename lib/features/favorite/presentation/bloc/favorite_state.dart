import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteState {}

class FavoriteStateInitial extends FavoriteState {}

class FavoriteStateLoading extends FavoriteState {}

class FavoriteStateLoaded extends FavoriteState {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> result;

  FavoriteStateLoaded({required this.result});
}

class FavoriteStateError extends FavoriteState {
  final String message;

  FavoriteStateError({required this.message});
}
