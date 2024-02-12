import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:street_calle/screens/auth/cubit/checkbox/checkbox_state.dart';

class CheckBoxCubit extends Cubit<CheckBoxStates> {
  CheckBoxCubit() : super(const CheckBoxStates());

  void enableOrDisableCheckBox() {
    emit(state.copyWith(isSwitch: !state.isSwitch));
  }
}