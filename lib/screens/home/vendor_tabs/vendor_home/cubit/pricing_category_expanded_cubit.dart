import 'package:flutter_bloc/flutter_bloc.dart';

class PricingCategoryExpandedCubit extends Cubit<bool> {
  PricingCategoryExpandedCubit() : super(false);

  void expand() => emit(true);
  void collapse() => emit(false);
}