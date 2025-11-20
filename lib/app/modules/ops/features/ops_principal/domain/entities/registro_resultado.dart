import 'package:equatable/equatable.dart';

class RegistroResultado extends Equatable {
  RegistroResultado({
    required this.id,
    required this.opsRegistroGeneralesId,
    required this.opsListaVerifPreguntaId,
    required this.opsListaVerifSeccionId,
    required this.opsListaVerifCategoriaId,
    required this.opsListaVerifResultadoId,
    required this.observacion,
    required this.rutaImagen,
    required this.nombreImagen,
    required this.idGeneradoSyncronizacion,
    required this.auxCodigo,
    required this.estado,
  });

  final int id;
  final String opsRegistroGeneralesId;
  final String opsListaVerifPreguntaId;
  final String opsListaVerifSeccionId;
  final String opsListaVerifCategoriaId;
  final String opsListaVerifResultadoId;
  final String observacion;
  final String rutaImagen;
  final String nombreImagen;
  final String idGeneradoSyncronizacion;
  final String auxCodigo;
  final int estado;

  @override
  List<Object> get props => [
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
        estado
      ];
}
