import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class GetRegistrarResultadoStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    String idGenerales,
    String idCategoria,
    String idSeccion,
    String idPregunta,
  );
}

class GetRegistrarResultadoStorageUcImpl
    implements GetRegistrarResultadoStorageUc<RegistroResultado, dynamic> {
  GetRegistrarResultadoStorageUcImpl({
    required ListaVerificacionLocalRepository local,
  }) : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, RegistroResultado>> call(
    String idGenerales,
    String idCategoria,
    String idSeccion,
    String idPregunta,
  ) async =>
      await _local.getRegistroResultadoFromStorage(
        idGenerales,
        idCategoria,
        idSeccion,
        idPregunta,
      );
}
