import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveGerenciasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<Gerencia> areas);
}

class SaveGerenciasLocalUcImpl implements SaveGerenciasLocalUc<bool, dynamic> {
  SaveGerenciasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<Gerencia> areas) async =>
      await _local.saveGerenciasToLocal(areas);
}
