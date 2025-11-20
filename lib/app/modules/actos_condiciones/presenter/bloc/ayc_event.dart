part of 'ayc_bloc.dart';

abstract class AyCEvent extends Equatable {
  const AyCEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends AyCEvent {
  final String idSede;

  const InitEv({required this.idSede});
  @override
  List<Object> get props => [idSede];
}

class UploadActosCondicionesEv extends AyCEvent {
  const UploadActosCondicionesEv({required this.actosCondiciones});
  final List<ActoCondicion> actosCondiciones;
  @override
  List<Object> get props => [actosCondiciones];
}

class DeleteActoCondicionEv extends AyCEvent {
  const DeleteActoCondicionEv({
    required this.actoCondicion,
  });
  final ActoCondicion actoCondicion;
  @override
  List<Object> get props => [actoCondicion];
}
