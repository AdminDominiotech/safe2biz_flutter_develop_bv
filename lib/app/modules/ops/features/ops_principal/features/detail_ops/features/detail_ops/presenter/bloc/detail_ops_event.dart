part of 'detail_ops_bloc.dart';

abstract class DetailOpsEvent extends Equatable {
  const DetailOpsEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends DetailOpsEvent {
  InitEv(this.pageArgs);
  final DetailOpsPageArgs pageArgs;
}

class ChangeDataEv extends DetailOpsEvent {
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

class SaveRegistroResultadoEv extends DetailOpsEvent {
  const SaveRegistroResultadoEv({
    required this.file1,
  });

  final File file1;
  @override
  List<Object> get props => [
        file1,
      ];
}

class EditRegistroResultadoEv extends DetailOpsEvent {
  const EditRegistroResultadoEv({
    required this.file1,
  });

  final File file1;
  @override
  List<Object> get props => [
        file1,
      ];
}

class UpdatePreguntasEv extends DetailOpsEvent {
  const UpdatePreguntasEv({
    required this.idGeneral,
    required this.idVerificacion,
  });

  final String idGeneral;
  final String idVerificacion;
  @override
  List<Object> get props => [idGeneral, idVerificacion];
}
