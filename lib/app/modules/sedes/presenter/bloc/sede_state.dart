part of 'sede_bloc.dart';

abstract class SedeState extends Equatable {
  const SedeState();

  @override
  List<Object> get props => [];
}

class CompanyInitial extends SedeState {}

class Loading extends SedeState {}

class Successful extends SedeState {
  const Successful({required this.sedes});
  final List<Sede> sedes;

  @override
  List<Object> get props => [sedes];
}

class FailureGetCompanies extends SedeState {
  const FailureGetCompanies({
    required this.error,
    required this.lastState,
  });
  final String error;
  final SedeState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureSaveCompanies extends SedeState {
  const FailureSaveCompanies({
    required this.error,
    required this.lastState,
  });
  final String error;
  final SedeState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
