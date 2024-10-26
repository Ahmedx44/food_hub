import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:food_hub/features/profile/presentation/bloc/user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  GetUserInfoUsecase getUserInfoUsecase;
  UserDataCubit(this.getUserInfoUsecase) : super(UserDataStateInitial());

  void getUserInfo() async {
    emit(UserDataStateLoading());
    final result = await getUserInfoUsecase();
    result.fold((error) {
      emit(UserDataStateError(message: error));
    }, (success) {
      emit(UserDataStateLoaded(result:success));
    });
  }
}
