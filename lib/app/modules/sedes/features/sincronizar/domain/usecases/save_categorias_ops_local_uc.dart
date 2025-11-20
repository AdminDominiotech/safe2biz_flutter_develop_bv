import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveCategoriasOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<CategoriaOps> categoriasOps);
}

class SaveCategoriasOpsLocalUcImpl
    implements SaveCategoriasOpsLocalUc<bool, dynamic> {
  SaveCategoriasOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(
    List<CategoriaOps> categoriasOps,
  ) async =>
      await _local.saveCategoriasOpsToLocal(categoriasOps);
}
