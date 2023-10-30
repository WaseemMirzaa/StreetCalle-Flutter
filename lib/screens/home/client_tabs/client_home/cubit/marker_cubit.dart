import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersState {
  final Set<Marker> markers;

  MarkersState(this.markers);
}

class MarkersCubit extends Cubit<MarkersState> {
  MarkersCubit() : super(MarkersState(<Marker>{}));

  void setMarkers(Set<Marker> markers) {
    emit(MarkersState(markers));
  }
}