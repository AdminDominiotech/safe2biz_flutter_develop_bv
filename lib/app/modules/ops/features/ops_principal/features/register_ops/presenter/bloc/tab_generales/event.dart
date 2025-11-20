part of 'bloc.dart';

abstract class TabOpsEvent extends Equatable {
  const TabOpsEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends TabOpsEvent {
  const InitEv(this.pageArgs);
  final RegisterOpsPrincipalPageArgs pageArgs;

  @override
  List<Object> get props => [pageArgs];
}

class SaveListaVerificacionEv extends TabOpsEvent {
  const SaveListaVerificacionEv({required this.registroGeneral});
  final RegistroGeneral registroGeneral;

  @override
  List<Object> get props => [registroGeneral];
}

class UpdatePreguntasEv extends TabOpsEvent {
  const UpdatePreguntasEv({
    required this.idGeneral,
    required this.idVerificacion,
  });

  final String idGeneral;
  final String idVerificacion;
  @override
  List<Object> get props => [idGeneral, idVerificacion];
}
