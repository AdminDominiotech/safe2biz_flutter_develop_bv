part of 'ops_main_bloc.dart';

abstract class OpsMainEvent extends Equatable {
  const OpsMainEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends OpsMainEvent {
  final String idSede;
  final String idListaVerificacion;

  const InitEv({required this.idSede, required this.idListaVerificacion});
  @override
  List<Object> get props => [idSede, idListaVerificacion];
}

class UploadListaVerificacionEv extends OpsMainEvent {
  const UploadListaVerificacionEv({required this.registroGeneral});
  final List<RegistroGeneral> registroGeneral;
  @override
  List<Object> get props => [registroGeneral];
}

class UpdatePreguntasEv extends OpsMainEvent {
  const UpdatePreguntasEv(
      {required this.idGeneral, required this.idVerificacion});

  final String idGeneral;
  final String idVerificacion;
  @override
  List<Object> get props => [idGeneral, idVerificacion];
}

class DeleteListaVerificacionEv extends OpsMainEvent {
  const DeleteListaVerificacionEv({
    required this.registroGeneral,
  });
  final RegistroGeneral registroGeneral;
  @override
  List<Object> get props => [registroGeneral];
}
