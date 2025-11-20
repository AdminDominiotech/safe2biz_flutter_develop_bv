part of 'map_view_cubit.dart';

abstract class MapViewState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapViewInitial extends MapViewState {}

class MapViewLoading extends MapViewState {}

class MapViewLoaded extends MapViewState {
  MapViewLoaded({required this.position});
  final LatLng position;
  @override
  List<Object> get props => [position];
}
