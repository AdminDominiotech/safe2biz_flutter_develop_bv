import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class GetRegistrarResultadoByIdGeneralStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    String idGenerales,
  );
}

class GetRegistrarResultadoByIdGeneralStorageUcImpl
    implements
        GetRegistrarResultadoByIdGeneralStorageUc<List<RegistroResultado>,
            dynamic> {
  GetRegistrarResultadoByIdGeneralStorageUcImpl({
    required ListaVerificacionLocalRepository local,
  }) : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, List<RegistroResultado>>> call(
    String idGenerales,
  ) async =>
      await _local.getRegistroResultadoByIdGeneralFromStorage(
        idGenerales,
      );
}
