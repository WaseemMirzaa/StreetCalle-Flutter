import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplyFilterCubit extends Cubit<bool> {
  ApplyFilterCubit() : super(false);

  applyFilter()=> emit(true);
  resetApplyFilter()=> emit(false);

  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final distanceController = TextEditingController();

  void clear() {
    minPriceController.clear();
    maxPriceController.clear();
    distanceController.clear();
  }

  @override
  Future<void> close() {
    minPriceController.dispose();
    maxPriceController.dispose();
    distanceController.dispose();
    return super.close();
  }
}