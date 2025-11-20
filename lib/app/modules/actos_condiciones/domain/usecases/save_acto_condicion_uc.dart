import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveActoCondicionUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    ActoCondicion actoCondicion,
  );
}

class SaveActoCondicionUcImpl implements SaveActoCondicionUc<bool, dynamic> {
  SaveActoCondicionUcImpl({required ActosCondicionesApiRepository repository})
      : _repository = repository;

  final ActosCondicionesApiRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    ActoCondicion actoCondicion,
  ) async =>
      await _repository.saveActosCondiciones(actoCondicion);
}
