import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_view_state.dart';

class MapViewCubit extends Cubit<MapViewState> {
  MapViewCubit() : super(MapViewInitial());

  LatLng? _latLng;

  Future<void> onMapCameraIdle() async {
    if (_latLng != null) {
      emit(MapViewLoading());
      await Future.delayed(const Duration(milliseconds: 350));
      emit(MapViewLoaded(position: _latLng!));
    }
  }

  Future<void> onMapCameraMove(CameraPosition position) async {
    _latLng = position.target;
  }
}
