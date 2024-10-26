import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataState {}

class UserDataStateLoading extends UserDataState {}

class UserDataStateInitial extends UserDataState {}

class UserDataStateLoaded extends UserDataState {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> result;

  UserDataStateLoaded({required this.result});
}

class UserDataStateError extends UserDataState {
  final String message;

  UserDataStateError({required this.message});
}
