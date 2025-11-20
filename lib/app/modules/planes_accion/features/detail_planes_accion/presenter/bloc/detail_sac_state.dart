part of 'detail_sac_bloc.dart';

abstract class DetailSACState extends Equatable {
  const DetailSACState();

  @override
  List<Object> get props => [];
}

class Init extends DetailSACState {}

class Loading extends DetailSACState {}

class Loaded extends DetailSACState {
  const Loaded({
    required this.planAccion,
  });
  final PlanAccion planAccion;
  @override
  List<Object> get props => [
        planAccion,
      ];
}

class UploadingPlanAccion extends DetailSACState {}

class UploadedPlanAccion extends DetailSACState {}

class EditingPlanAccion extends DetailSACState {}

class EditedPlanAccion extends DetailSACState {}

class FailureEditPlanAccion extends DetailSACState {
  const FailureEditPlanAccion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailSACState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadPlanAccion extends DetailSACState {
  const FailureUploadPlanAccion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailSACState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class DeletingPlanAccion extends DetailSACState {
  const DeletingPlanAccion() : super();
}

class DeletedPlanAccion extends DetailSACState {
  const DeletedPlanAccion() : super();
}

class FailureDeletePlanAccion extends DetailSACState {
  const FailureDeletePlanAccion({
    required this.error,
    required this.lastState,
  }) : super();
  final String error;
  final DetailSACState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
