import 'package:flutter_bloc/flutter_bloc.dart';

class ClientSelectedVendorCubit extends Cubit<String?>{
  ClientSelectedVendorCubit() : super(null);

  void selectedVendorId(String? id)=> emit(id);

}