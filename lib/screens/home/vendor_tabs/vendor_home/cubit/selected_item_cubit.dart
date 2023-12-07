import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedItemsCubit extends Cubit<List<String>> {
  SelectedItemsCubit() : super([]);

  void toggleItem(String itemId) {
    if (state.contains(itemId)) {
      emit(state.where((id) => id != itemId).toList());
    } else {
      emit([...state, itemId]);
    }
  }
}