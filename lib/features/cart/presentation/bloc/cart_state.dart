import 'package:food_hub/features/home/domain/entity/cart_entity.dart';

class CartState {}

class CartStateInitial extends CartState {}

class CartStateLoading extends CartState {}

class CartStateLoaded extends CartState {
  final List<CartItem> cartItem;

  CartStateLoaded({required this.cartItem});
}

class CartStateError extends CartState {}
