part of 'detail_ayc_bloc.dart';

abstract class DetailAycEvent extends Equatable {
  const DetailAycEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends DetailAycEvent {
  const InitEv({required this.actoCondicion});

  final ActoCondicion actoCondicion;
  @override
  List<Object> get props => [actoCondicion];
}

class ChangeDataEv extends DetailAycEvent {
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
    this.bsafId,
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
  final String? bsafId;
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
        bsafId,
        tarjetaRoja,
        interiorMina,
        interiorMinaNivel,
        interiorMinaLabor,
        interiorMinaNumeroLabor,
        estado,
      ];
}

class EditActoCondicionEv extends DetailAycEvent {
  const EditActoCondicionEv({this.file1, this.file2});

  final File? file1;
  final File? file2;

  @override
  List<Object?> get props => [file1, file2];
}

class UploadActoCondicionEv extends DetailAycEvent {
  const UploadActoCondicionEv({required this.actoCondicion});
  final ActoCondicion actoCondicion;
  @override
  List<Object> get props => [actoCondicion];
}

class DeleteActoCondicionEv extends DetailAycEvent {
  const DeleteActoCondicionEv({
    required this.actoCondicion,
  });
  final ActoCondicion actoCondicion;
  @override
  List<Object> get props => [actoCondicion];
}
