import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetCategoriasOpsUc<Output, Input> {
  Future<Either<Failure, Output>> call(String userLogin);
}

class GetCategoriasOpsUcImpl
    implements GetCategoriasOpsUc<List<CategoriaOps>, dynamic> {
  GetCategoriasOpsUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<CategoriaOps>>> call(String userLogin) async =>
      await _repository.getCategoriasOpsFromApi(userLogin);
}
