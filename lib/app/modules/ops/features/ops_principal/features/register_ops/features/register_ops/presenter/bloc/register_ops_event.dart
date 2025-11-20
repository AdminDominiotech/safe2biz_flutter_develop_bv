part of 'register_ops_bloc.dart';

abstract class RegisterOpsEvent extends Equatable {
  const RegisterOpsEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends RegisterOpsEvent {
  InitEv(this.pageArgs);
  final RegisterOpsPageArgs pageArgs;
}

class ChangeDataEv extends RegisterOpsEvent {
  const ChangeDataEv({
    this.id,
    this.opsRegistroGeneralesId,
    this.opsListaVerifPreguntaId,
    this.opsListaVerifSeccionId,
    this.opsListaVerifCategoriaId,
    this.opsListaVerifResultadoId,
    this.observacion,
    this.rutaImagen,
    this.nombreImagen,
    this.idGeneradoSyncronizacion,
    this.auxCodigo,
  });

  final int? id;
  final String? opsRegistroGeneralesId;
  final String? opsListaVerifPreguntaId;
  final String? opsListaVerifSeccionId;
  final String? opsListaVerifCategoriaId;
  final String? opsListaVerifResultadoId;
  final String? observacion;
  final String? rutaImagen;
  final String? nombreImagen;
  final String? idGeneradoSyncronizacion;
  final String? auxCodigo;

  @override
  List<Object?> get props => [
        id,
        opsRegistroGeneralesId,
        opsListaVerifPreguntaId,
        opsListaVerifSeccionId,
        opsListaVerifCategoriaId,
        opsListaVerifResultadoId,
        observacion,
        rutaImagen,
        nombreImagen,
        idGeneradoSyncronizacion,
        auxCodigo,
      ];
}

class SaveRegistroResultadoEv extends RegisterOpsEvent {
  const SaveRegistroResultadoEv({
    required this.file1,
  });

  final File file1;
  @override
  List<Object> get props => [
        file1,
      ];
}

class UpdatePreguntasEv extends RegisterOpsEvent {
  const UpdatePreguntasEv({
    required this.idGeneral,
    required this.idVerificacion,
  });

  final String idGeneral;
  final String idVerificacion;
  @override
  List<Object> get props => [idGeneral, idVerificacion];
}
