import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetAllCart getAllCart;

  CartCubit(this.getAllCart) : super(CartStateInitial());

  Future<void> getCart() async {
    emit(CartStateLoading());

    final result = await getAllCart.call();
    result.fold((ifLeft) {
      emit(CartStateError());
    }, (ifRight) {
      emit(CartStateLoaded(cartItem: ifRight));
    });
  }
}
