import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/constant/constants.dart';

class MapFilterCubit extends Cubit<String> {
  MapFilterCubit() : super(defaultVendorFilter);

  void updateFilter(String query) {
    emit(query);
  }
}

class MenuItemFilterCubit extends Cubit<String> {
  MenuItemFilterCubit() : super(defaultVendorFilter);

  void updateFilter(String query) {
    emit(query);
  }
}

class MenuDealFilterCubit extends Cubit<String> {
  MenuDealFilterCubit() : super(defaultVendorFilter);

  void updateFilter(String query) {
    emit(query);
  }
}

class VendorFilterCubit extends Cubit<String> {
  VendorFilterCubit() : super(defaultVendorFilter);

  void updateFilter(String query) {
    emit(query);
  }
}