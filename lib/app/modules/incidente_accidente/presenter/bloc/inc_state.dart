part of 'inc_bloc.dart';

abstract class INCState extends Equatable {
  const INCState(
    this.model,
  );
  final Model model;

  @override
  List<Object> get props => [model];
}

class Init extends INCState {
  Init(Model model) : super(model);
}

class Loading extends INCState {
  Loading(Model model) : super(model);
}

class Loaded extends INCState {
  const Loaded(Model model) : super(model);

  @override
  List<Object> get props => [];
}

class FailureGetIncidentesAccidentes extends INCState {
  const FailureGetIncidentesAccidentes({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final INCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class UploadingIncidentesAccidentes extends INCState {
  const UploadingIncidentesAccidentes(Model model) : super(model);
}

class UploadedIncidentesAccidentes extends INCState {
  const UploadedIncidentesAccidentes(
    Model model, {
    required this.message,
  }) : super(model);
  final String message;
  @override
  List<Object> get props => [message];
}

class DeletingIncidenteAccidente extends INCState {
  const DeletingIncidenteAccidente(Model model) : super(model);
}

class DeletedIncidenteAccidente extends INCState {
  const DeletedIncidenteAccidente(Model model) : super(model);
}

class FailureDeleteIncidenteAccidente extends INCState {
  const FailureDeleteIncidenteAccidente({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final INCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadIncidentesAccidentes extends INCState {
  const FailureUploadIncidentesAccidentes({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final INCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class Model extends Equatable {
  const Model({
    this.idSede = '',
    this.incidentesAccidentes = const [],
  });

  final String idSede;
  final List<IncidenteAccidente> incidentesAccidentes;

  Model copyWith({
    String? idSede,
    List<IncidenteAccidente>? incidentesAccidentes,
  }) {
    return Model(
      idSede: idSede ?? this.idSede,
      incidentesAccidentes: incidentesAccidentes ?? this.incidentesAccidentes,
    );
  }

  @override
  List<Object> get props => [incidentesAccidentes];
}
