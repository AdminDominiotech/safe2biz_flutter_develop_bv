import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetGerenciasLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetGerenciasLocalUcImpl
    implements GetGerenciasLocalUc<List<Gerencia>, dynamic> {
  GetGerenciasLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<Gerencia>>> call() async =>
      await _local.getGerenciasFromLocal();
}
