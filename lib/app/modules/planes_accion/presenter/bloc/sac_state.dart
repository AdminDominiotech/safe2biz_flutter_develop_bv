part of 'sac_bloc.dart';

abstract class SACState extends Equatable {
  const SACState(
    this.model,
  );
  final Model model;

  @override
  List<Object> get props => [model];
}

class Init extends SACState {
  Init(Model model) : super(model);
}

class Loading extends SACState {
  Loading(Model model) : super(model);
}

class Loaded extends SACState {
  const Loaded(Model model) : super(model);

  @override
  List<Object> get props => [];
}

class FailureGetPlanesAccion extends SACState {
  const FailureGetPlanesAccion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final SACState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class UploadingPlanesAccion extends SACState {
  const UploadingPlanesAccion(Model model) : super(model);
}

class UploadedPlanesAccion extends SACState {
  const UploadedPlanesAccion(
    Model model, {
    required this.message,
  }) : super(model);
  final String message;
  @override
  List<Object> get props => [message];
}

class DeletingPlanesAccion extends SACState {
  const DeletingPlanesAccion(Model model) : super(model);
}

class DeletedPlanesAccion extends SACState {
  const DeletedPlanesAccion(Model model) : super(model);
}

class FailureDeletePlanesAccion extends SACState {
  const FailureDeletePlanesAccion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final SACState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadPlanesAccion extends SACState {
  const FailureUploadPlanesAccion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final SACState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class Model extends Equatable {
  const Model({
    this.planesAccion = const [],
    this.idSede = '',
  });

  final List<PlanAccion> planesAccion;
  final String idSede;

  Model copyWith({
    String? idSede,
    List<PlanAccion>? planesAccion,
  }) {
    return Model(
      idSede: idSede ?? this.idSede,
      planesAccion: planesAccion ?? this.planesAccion,
    );
  }

  @override
  List<Object> get props => [planesAccion];
}
