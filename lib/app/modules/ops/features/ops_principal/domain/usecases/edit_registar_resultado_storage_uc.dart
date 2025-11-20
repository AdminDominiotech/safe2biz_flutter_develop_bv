import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class EditRegistrarResultadoStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    RegistroResultado registroResultado,
  );
}

class EditRegistrarResultadoStorageUcImpl
    implements EditRegistrarResultadoStorageUc<bool, dynamic> {
  EditRegistrarResultadoStorageUcImpl(
      {required ListaVerificacionLocalRepository local})
      : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    RegistroResultado registroResultado,
  ) async =>
      await _local.editRegistroResultadoFromStorage(registroResultado);
}
