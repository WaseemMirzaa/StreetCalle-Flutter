import 'package:flutter_bloc/flutter_bloc.dart';

class FoodTypeDropDownCubit extends Cubit<bool> {
  FoodTypeDropDownCubit() : super(false);

  void addFoodTypeSelected()=> emit(true);
  void resetState()=> emit(false);
}