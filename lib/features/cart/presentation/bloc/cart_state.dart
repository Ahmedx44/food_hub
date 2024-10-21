// Base class for CartState
import 'package:food_hub/features/home/data/model/cart_model.dart';

abstract class CartState {}

// State when the cart is being loaded (e.g., fetching data from Firestore)
class CartStateLoading extends CartState {}

// State when the cart is successfully loaded with cart items
class CartStateLoaded extends CartState {
  final Stream<List<CartModel>> cartItem;

  CartStateLoaded({required this.cartItem});
}

// State when there's an error loading the cart
class CartStateError extends CartState {
  final String error;

  CartStateError(this.error);
}

// Initial state when the cart has not been fetched yet
class CartStateInitial extends CartState {}
