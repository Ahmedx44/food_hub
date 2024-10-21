import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/domain/usecase/get_all_cart.dart';
import 'package:food_hub/features/cart/domain/usecase/update_quantity_usecase.dart';
import 'package:food_hub/features/cart/presentation/bloc/cart_state.dart';
import 'package:food_hub/service_locator.dart';

class CartCubit extends Cubit<CartState> {
  final GetAllCart getAllCart;

  CartCubit(this.getAllCart) : super(CartStateInitial());

  void getCart() {
    emit(CartStateLoading());

    final futureResult = getAllCart();

    futureResult.then((stream) {
      emit(CartStateLoaded(cartItem: stream));
    }).catchError((error) {
      emit(CartStateError(error.toString()));
    });
  }

  void updateQuantity(String itemid, int quantity) {
    sl<UpdateQuantityUsecase>().call(itemid, quantity);
  }
}
