part of 'ayc_bloc.dart';

abstract class AyCState extends Equatable {
  const AyCState(
    this.model,
  );
  final Model model;

  @override
  List<Object> get props => [model];
}

class Init extends AyCState {
  Init(Model model) : super(model);
}

class Loading extends AyCState {
  Loading(Model model) : super(model);
}

class Loaded extends AyCState {
  const Loaded(Model model) : super(model);

  @override
  List<Object> get props => [];
}

class FailureGetActosCondiciones extends AyCState {
  const FailureGetActosCondiciones({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final AyCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class UploadingActosCondiciones extends AyCState {
  const UploadingActosCondiciones(Model model) : super(model);
}

class UploadedActosCondiciones extends AyCState {
  const UploadedActosCondiciones(
    Model model, {
    required this.message,
  }) : super(model);
  final String message;
  @override
  List<Object> get props => [message];
}

class DeletingActoCondicion extends AyCState {
  const DeletingActoCondicion(Model model) : super(model);
}

class DeletedActoCondicion extends AyCState {
  const DeletedActoCondicion(Model model) : super(model);
}

class FailureDeleteActoCondicion extends AyCState {
  const FailureDeleteActoCondicion({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final AyCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadActosCondiciones extends AyCState {
  const FailureUploadActosCondiciones({
    required this.error,
    required this.lastState,
    required Model model,
  }) : super(model);
  final String error;
  final AyCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class Model extends Equatable {
  const Model({
    this.idSede = '',
    this.actosCondiciones = const [],
  });

  final String idSede;
  final List<ActoCondicion> actosCondiciones;

  Model copyWith({
    String? idSede,
    List<ActoCondicion>? actosCondiciones,
  }) {
    return Model(
      idSede: idSede ?? this.idSede,
      actosCondiciones: actosCondiciones ?? this.actosCondiciones,
    );
  }

  @override
  List<Object> get props => [actosCondiciones];
}
