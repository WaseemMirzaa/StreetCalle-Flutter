import 'package:flutter_bloc/flutter_bloc.dart';

class FoodTypeExpandedCubit extends Cubit<bool> {
  FoodTypeExpandedCubit() : super(false);

  void expand() => emit(true);
  void collapse() => emit(false);
}