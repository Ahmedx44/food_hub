import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/order/domain/usecase/get_user_orders.dart';
import 'package:food_hub/features/order/presentation/bloc/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  GetUserOrdersUseCase getUserOrdersUseCase;
  OrderCubit(this.getUserOrdersUseCase) : super(OrderStateIntitial());

  getUserOrder() async {
    emit(OrderStateLoading());
    final result = await getUserOrdersUseCase();

    result.fold((error) {
      emit(OrderStateError(message: error));
    }, (succes) {
      emit(OrderStateLoaded(result: succes));
    });
  }
}
