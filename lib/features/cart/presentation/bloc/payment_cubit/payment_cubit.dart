import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/cart/data/model/order_model.dart';
import 'package:food_hub/features/cart/domain/usecase/make_order_usecase.dart';
import 'package:food_hub/features/cart/presentation/bloc/payment_cubit/payment_state.dart';
import 'package:food_hub/service_locator.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentStateIntial());

  Future makeOrder(OrderModel orderModel) async {
    emit(PaymentStateLoading());
    final result = await sl<MakeOrderUsecase>().call(orderModel);
  }
}
