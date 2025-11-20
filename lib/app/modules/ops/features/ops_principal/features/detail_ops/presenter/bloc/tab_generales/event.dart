part of 'bloc.dart';

abstract class TabGeneralDetailOpsEvent extends Equatable {
  const TabGeneralDetailOpsEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends TabGeneralDetailOpsEvent {
  const InitEv(this.idGeneral);
  final String idGeneral;

  @override
  List<Object> get props => [idGeneral];
}

class EditListaVerificacionEv extends TabGeneralDetailOpsEvent {
  const EditListaVerificacionEv({required this.registroGeneral});
  final RegistroGeneral registroGeneral;

  @override
  List<Object> get props => [registroGeneral];
}

class UploadRegistrosGeneralesEv extends TabGeneralDetailOpsEvent {
  const UploadRegistrosGeneralesEv({
    required this.registroGeneral,
    required this.registrosResultados,
    required this.idSede,
    required this.idUser,
  });
  final RegistroGeneral registroGeneral;
  final List<RegistroResultado> registrosResultados;
  final String idSede;
  final String idUser;

  @override
  List<Object> get props => [
        registroGeneral,
        registrosResultados,
        idSede,
        idUser,
      ];
}

class DeleteRegistrosGeneralesEv extends TabGeneralDetailOpsEvent {
  const DeleteRegistrosGeneralesEv({
    required this.registroGeneral,
  });
  final RegistroGeneral registroGeneral;
  @override
  List<Object> get props => [registroGeneral];
}
