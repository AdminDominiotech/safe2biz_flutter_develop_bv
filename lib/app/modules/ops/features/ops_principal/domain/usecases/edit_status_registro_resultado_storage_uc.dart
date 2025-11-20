import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/lista_verificacion_local_repository.dart';

abstract class EditStatusRegistroResultadoStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    int id,
    String status,
  );
}

class EditStatusRegistroResultadoStorageUcImpl
    implements EditStatusRegistroResultadoStorageUc<bool, dynamic> {
  EditStatusRegistroResultadoStorageUcImpl(
      {required ListaVerificacionLocalRepository local})
      : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    int id,
    String status,
  ) async =>
      await _local.editStatusRegistroResultadoFromStorage(id, status);
}
