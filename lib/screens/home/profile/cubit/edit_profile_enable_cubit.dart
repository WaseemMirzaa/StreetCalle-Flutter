import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileEnableCubit extends Cubit<bool> {
  EditProfileEnableCubit() : super(false);

  void editButtonClicked() => emit(true);
  void updateButtonClicked() => emit(false); /// update button click to make change the state
}