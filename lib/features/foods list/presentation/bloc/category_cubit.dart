import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/features/foods%20list/data/model/category_model.dart';
import 'package:food_hub/features/foods%20list/domain/usecase/get_category_usecase.dart';
import 'package:food_hub/features/foods%20list/presentation/bloc/category_state.dart';
import 'package:food_hub/service_locator.dart';

class CategoryCubit extends Cubit<CategoryState> {
  GetCategoryUsecase getCategoryUsecase;
  CategoryCubit(this.getCategoryUsecase) : super(CategoryStateInitial());

  getCategory(String category) async {
    emit(CategoryStateLoading());
    final result = await sl<GetCategoryUsecase>()
        .call(CategoryModel(categoryName: category));

    result.fold((error) {
      emit(CategoryStateError(error: error));
    }, (success) {
      emit(CategoryStateLoaded(result: success));
    });
  }
}
