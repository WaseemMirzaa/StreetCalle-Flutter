import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyFilterCubit extends Cubit<bool> {
  ApplyFilterCubit() : super(false);

  applyFilter()=> emit(true);
  resetApplyFilter()=> emit(false);
}