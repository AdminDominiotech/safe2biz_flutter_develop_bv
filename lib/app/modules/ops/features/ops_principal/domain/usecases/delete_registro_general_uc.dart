import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class DeleteRegistroGeneralStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(int id);
}

class DeleteRegistroGeneralStorageUcImpl
    implements DeleteRegistroGeneralStorageUc<bool, dynamic> {
  DeleteRegistroGeneralStorageUcImpl({
    required ListaVerificacionLocalRepository local,
  }) : _local = local;

  final ListaVerificacionLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(int id) async =>
      await _local.deleteRegistroGeneralFromStorage(id);
}
