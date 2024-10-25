import 'package:cloud_firestore/cloud_firestore.dart';

class OrderState {}

class OrderStateIntitial extends OrderState {}

class OrderStateLoading extends OrderState {}

class OrderStateLoaded extends OrderState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> result;

  OrderStateLoaded({required this.result});
}

class OrderStateError extends OrderState {
  final String message;

  OrderStateError({required this.message});
}
