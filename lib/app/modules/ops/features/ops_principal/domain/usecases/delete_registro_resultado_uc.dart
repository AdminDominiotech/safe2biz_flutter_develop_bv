import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class DeleteRegistroResultadoStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(String id);
}

class DeleteRegistroResultadoStorageUcImpl
    implements DeleteRegistroResultadoStorageUc<bool, dynamic> {
  DeleteRegistroResultadoStorageUcImpl({
    required ListaVerificacionLocalRepository local,
  }) : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(String id) async =>
      await _local.deleteRegistroResultadoFromStorage(id);
}
