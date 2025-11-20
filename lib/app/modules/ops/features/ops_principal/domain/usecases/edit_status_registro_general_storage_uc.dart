import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/lista_verificacion_local_repository.dart';

abstract class EditStatusRegistroGeneralStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    int id,
    String status,
  );
}

class EditStatusRegistroGeneralStorageUcImpl
    implements EditStatusRegistroGeneralStorageUc<bool, dynamic> {
  EditStatusRegistroGeneralStorageUcImpl({
    required ListaVerificacionLocalRepository local,
  }) : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    int id,
    String status,
  ) async =>
      await _local.editStatusRegistroGeneralesFromStorage(id, status);
}
