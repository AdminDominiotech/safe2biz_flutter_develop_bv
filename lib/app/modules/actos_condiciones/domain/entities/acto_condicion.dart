import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class ActoCondicion extends Equatable {
  ActoCondicion({
    required this.id,
    required this.origen,
    required this.gTipoCausaId,
    required this.gTipoCausaNombre,
    required this.fbGerencia,
    required this.fbGerenciaNombre,
    required this.fbAreaId,
    required this.fbAreaNombre,
    required this.descripcion,
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.corrigio,
    required this.tipoEventoId,
    required this.tipoEventoNombre,
    required this.nivelRiesgoId,
    required this.nivelRiesgoNombre,
    required this.accionEjec,
    required this.fbEmpresaEspecializadaId,
    required this.fbEmpresaEspecializadaNombre,
    required this.latitud,
    required this.longitud,
    required this.fotoPreEventoNombre,
    required this.fotoPreEventoRuta,
    required this.fotoEventoNombre,
    required this.fotoEventoRuta,
    required this.fbEmpleadoId,
    required this.fbEmpleadoNombre,
    required this.fbUeaPeId,

    required this.bsafId,
    required this.tarjetaRoja,
    required this.interiorMina,
    required this.interiorMinaNivel,
    required this.interiorMinaLabor,
    required this.interiorMinaNumeroLabor,
    required this.estado,
  });

  /// ayc_registro_id
  int id;
  String origen;
  String gTipoCausaId;
  String gTipoCausaNombre;
  String fbGerencia;
  String fbGerenciaNombre;
  String fbAreaId;
  String fbAreaNombre;
  String descripcion;
  String lugar;
  String fecha;
  String hora;
  String corrigio;
  String tipoEventoId;
  String tipoEventoNombre;
  String nivelRiesgoId;
  String nivelRiesgoNombre;
  String accionEjec;
  String fbEmpresaEspecializadaId;
  String fbEmpresaEspecializadaNombre;
  String latitud;
  String longitud;
  String fotoPreEventoNombre;
  String fotoPreEventoRuta;
  String fotoEventoNombre;
  String fotoEventoRuta;
  String fbEmpleadoId;
  String fbEmpleadoNombre;
  String fbUeaPeId;
  String bsafId;
  String tarjetaRoja;
  String interiorMina;
  String interiorMinaNivel;
  String interiorMinaLabor;
  String interiorMinaNumeroLabor;

  /// 0: create,1: online
  String estado;

  @override
  List<Object> get props => [
        origen,
        gTipoCausaId,
        gTipoCausaNombre,
        fbGerencia,
        fbGerenciaNombre,
        fbAreaId,
        fbAreaNombre,
        descripcion,
        lugar,
        fecha,
        hora,
        corrigio,
        tipoEventoId,
        tipoEventoNombre,
        nivelRiesgoId,
        nivelRiesgoNombre,
        accionEjec,
        fbEmpresaEspecializadaId,
        fbEmpresaEspecializadaNombre,
        latitud,
        longitud,
        fotoPreEventoNombre,
        fotoPreEventoRuta,
        fotoEventoNombre,
        fotoEventoRuta,
        fbEmpleadoId,
        fbEmpleadoNombre,
        fbUeaPeId,
        bsafId,
        tarjetaRoja,
        interiorMina,
        interiorMinaNivel,
        interiorMinaLabor,
        interiorMinaNumeroLabor,
        estado,
  ];
}
