part of 'sac_bloc.dart';

abstract class SACEvent extends Equatable {
  const SACEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends SACEvent {
  final String idSede;

  const InitEv({required this.idSede});
  @override
  List<Object> get props => [idSede];
}

class UploadPlanesAccionEv extends SACEvent {
  const UploadPlanesAccionEv({required this.planesAccion});
  final List<PlanAccion> planesAccion;
  @override
  List<Object> get props => [planesAccion];
}

class DeletePlanAccionEv extends SACEvent {
  const DeletePlanAccionEv({
    required this.planAccion,
  });
  final PlanAccion planAccion;
  @override
  List<Object> get props => [planAccion];
}
