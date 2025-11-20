part of 'ops_main_bloc.dart';

abstract class OpsMainState extends Equatable {
  const OpsMainState(
    this.model,
  );
  final Model model;

  @override
  List<Object> get props => [model];
}

class Init extends OpsMainState {
  Init(Model model) : super(model);
}

class Loading extends OpsMainState {
  Loading(Model model) : super(model);
}

class Loaded extends OpsMainState {
  const Loaded(Model model) : super(model);

  @override
  List<Object> get props => [];
}

class FailureGetListaVerificacion extends OpsMainState {
  const FailureGetListaVerificacion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final OpsMainState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class UploadingListaVerificacion extends OpsMainState {
  const UploadingListaVerificacion(Model model) : super(model);
}

class UploadedListaVerificacion extends OpsMainState {
  const UploadedListaVerificacion(
    Model model, {
    required this.message,
  }) : super(model);
  final String message;
  @override
  List<Object> get props => [message];
}

class DeletingListaVerificacion extends OpsMainState {
  const DeletingListaVerificacion(Model model) : super(model);
}

class DeletedListaVerificacion extends OpsMainState {
  const DeletedListaVerificacion(Model model) : super(model);
}

class FailureDeleteListaVerificacion extends OpsMainState {
  const FailureDeleteListaVerificacion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final OpsMainState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadListaVerificacion extends OpsMainState {
  const FailureUploadListaVerificacion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final OpsMainState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class Model extends Equatable {
  const Model({
    this.idSede = '',
    this.registroGeneral = const [],
  });

  final String idSede;
  final List<RegistroGeneral> registroGeneral;

  Model copyWith({
    String? idSede,
    List<RegistroGeneral>? registroGeneral,
  }) {
    return Model(
      idSede: idSede ?? this.idSede,
      registroGeneral: registroGeneral ?? this.registroGeneral,
    );
  }

  @override
  List<Object> get props => [registroGeneral];
}
