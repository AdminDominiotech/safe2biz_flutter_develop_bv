import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetCategoriasOpsLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetCategoriasOpsLocalUcImpl
    implements GetCategoriasOpsLocalUc<List<CategoriaOps>, dynamic> {
  GetCategoriasOpsLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<CategoriaOps>>> call() async =>
      await _local.getCategoriasOpsFromLocal();
}
