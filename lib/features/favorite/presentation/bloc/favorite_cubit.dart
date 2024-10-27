import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/favorite/domain/usecase/get_user_favorite_usecase.dart';
import 'package:food_hub/features/favorite/presentation/bloc/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  GetUserFavoriteUsecase getUserFavoriteUsecase;
  FavoriteCubit(this.getUserFavoriteUsecase) : super(FavoriteStateInitial());

  getUserfavorite() async {
    emit(FavoriteStateLoading());
    final result = await getUserFavoriteUsecase();
    result.fold((error) {
      emit(FavoriteStateError(message: error));
    }, (succes) {
      emit(FavoriteStateLoaded(result: succes));
    });
  }
}
