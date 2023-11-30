import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';

class OnlineVendorsCubit extends Cubit<List<User>> {
  OnlineVendorsCubit() : super([]);

  addVendors(List<User> vendors) => emit(vendors);
  resetVendors() => emit([]);
}