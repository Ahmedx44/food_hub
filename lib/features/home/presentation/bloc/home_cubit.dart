import 'package:bloc/bloc.dart';
import 'package:food_hub/features/home/domain/usecase/get_item_usecase.dart';
import 'package:food_hub/features/home/presentation/bloc/home_state.dart';
import 'package:food_hub/service_locator.dart';

class HomeCubit extends Cubit<HomeState> {
  GetItemUsecase getItemUsecase;
  HomeCubit(this.getItemUsecase) : super(HomeStateIntitial());

  void getPopularItem() async {
    emit(HomeStateLoading());
    final result = await sl<GetItemUsecase>().call();
    result.fold((ifLeft) {
      emit(HomeStateLoadError(error: ifLeft));
    }, (ifRight) {
      emit(HomeStateLoaded(result: ifRight));
    });
  }
}
