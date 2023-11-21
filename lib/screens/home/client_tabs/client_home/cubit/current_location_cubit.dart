import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentLocationState {
  final double? latitude;
  final double? longitude;
  final double? updatedLatitude;
  final double? updatedLongitude;

  CurrentLocationState({
    this.latitude,
    this.longitude,
    this.updatedLatitude,
    this.updatedLongitude
  });

  CurrentLocationState copyWith({double? latitude, double? longitude, double? updatedLatitude, double? updatedLongitude}){
    return CurrentLocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      updatedLatitude: updatedLatitude ?? this.updatedLatitude,
      updatedLongitude: updatedLongitude ?? this.updatedLongitude
    );
  }
}

class CurrentLocationCubit extends Cubit<CurrentLocationState>{
  CurrentLocationCubit() : super(CurrentLocationState());

  setCurrentLocation({double? latitude, double? longitude}) => emit(state.copyWith(latitude: latitude, longitude: longitude));
  setUpdatedLocation({double? updatedLatitude, double? updatedLongitude}) => emit(state.copyWith(updatedLatitude: updatedLatitude, updatedLongitude: updatedLongitude));

}