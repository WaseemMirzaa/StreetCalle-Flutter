import 'package:flutter_bloc/flutter_bloc.dart';

class AddCustomItemCubit extends Cubit<bool> {
  AddCustomItemCubit() : super(false);

  void expand() => emit(true);
  void collapse() => emit(false);
}