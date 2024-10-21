import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetAllCart getAllCart;

  CartCubit(this.getAllCart) : super(CartStateInitial());

  void getCart() {
    emit(CartStateLoading());

    final futureResult =
        getAllCart(); // This returns a Future<Stream<List<CartModel>>>

    futureResult.then((stream) {
      emit(CartStateLoaded(
          cartItem: stream)); // On success, emit the loaded state
    }).catchError((error) {
      emit(CartStateError(error.toString())); // On error, emit an error state
    });
  }

  void updateQuantity() {}
}
