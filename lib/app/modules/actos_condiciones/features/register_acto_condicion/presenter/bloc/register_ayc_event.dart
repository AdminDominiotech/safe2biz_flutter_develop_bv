part of 'register_ayc_bloc.dart';

abstract class RegisterAyCEvent extends Equatable {
  const RegisterAyCEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends RegisterAyCEvent {}

class ChangeDataEv extends RegisterAyCEvent {
  const ChangeDataEv({
    this.id,
    this.origen,
    this.gTipoCausaId,
    this.gTipoCausaNombre,
    this.fbGerencia,
    this.fbGerenciaNombre,
    this.fbAreaId,
    this.fbAreaNombre,
    this.descripcion,
    this.lugar,
    this.fecha,
    this.hora,
    this.corrigio,
    this.tipoEventoId,
    this.tipoEventoNombre,
    this.nivelRiesgoId,
    this.nivelRiesgoNombre,
    this.accionEjec,
    this.fbEmpresaEspecializadaId,
    this.fbEmpresaEspecializadaNombre,
    this.latitud,
    this.longitud,
    this.fotoPreEventoNombre,
    this.fotoPreEventoRuta,
    this.fotoEventoNombre,
    this.fotoEventoRuta,
    this.fbEmpleadoId,
    this.fbEmpleadoNombre,
    this.fbUeaPeId,
    this.bsafID,
    this.tarjetaRoja,
    this.interiorMina,
    this.interiorMinaNivel,
    this.interiorMinaLabor,
    this.interiorMinaNumeroLabor,
    this.estado,
  });

  final int? id;
  final String? origen;
  final String? gTipoCausaId;
  final String? gTipoCausaNombre;
  final String? fbGerencia;
  final String? fbGerenciaNombre;
  final String? fbAreaId;
  final String? fbAreaNombre;
  final String? descripcion;
  final String? lugar;
  final String? fecha;
  final String? hora;
  final String? corrigio;
  final String? tipoEventoId;
  final String? tipoEventoNombre;
  final String? nivelRiesgoId;
  final String? nivelRiesgoNombre;
  final String? accionEjec;
  final String? fbEmpresaEspecializadaId;
  final String? fbEmpresaEspecializadaNombre;
  final String? latitud;
  final String? longitud;
  final String? fotoPreEventoNombre;
  final String? fotoPreEventoRuta;
  final String? fotoEventoNombre;
  final String? fotoEventoRuta;
  final String? fbEmpleadoId;
  final String? fbEmpleadoNombre;
  final String? fbUeaPeId;
  final String? bsafID;
  final String? tarjetaRoja;
  final String? interiorMina;
  final String? interiorMinaNivel;
  final String? interiorMinaLabor;
  final String? interiorMinaNumeroLabor;
  final String? estado;
  @override
  List<Object?> get props => [
        id,
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
        bsafID,
        tarjetaRoja,
        interiorMina,
        interiorMinaNivel,
        interiorMinaLabor,
        interiorMinaNumeroLabor,
        estado,
      ];
}

class SaveActoCondicionEv extends RegisterAyCEvent {
  const SaveActoCondicionEv({
    required this.file1,
    required this.file2,
  });
  // final ActoCondicion actoCondicion;
  final File? file1;
  final File? file2;

  @override
  List<Object?> get props => [file1, file2];
}
