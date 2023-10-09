import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pricing_category_state.dart';

class PricingCategoryCubit extends Cubit<PricingCategoryState> {
  PricingCategoryCubit() : super(PricingCategoryState(categoryType: PricingCategoryType.none));

  void setCategoryType(PricingCategoryType type) => emit(state.copyWith(categoryType: type));
}