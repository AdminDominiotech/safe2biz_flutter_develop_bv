import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class DeleteActoCondicionStorageUc<Output, Input> {
  Future<Either<Failure, Output>> call(int id);
}

class DeleteActoCondicionStorageUcImpl
    implements DeleteActoCondicionStorageUc<bool, dynamic> {
  DeleteActoCondicionStorageUcImpl({
    required ActosCondicionesLocalRepository local,
  }) : _local = local;

  final ActosCondicionesLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(int id) async =>
      await _local.deleteActoCondicionStorage(id);
}
