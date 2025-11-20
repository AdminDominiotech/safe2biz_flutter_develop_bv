import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';

abstract class SaveRegistrosGeneralesUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  );
}

class SaveRegistrosGeneralesUcImpl
    implements SaveRegistrosGeneralesUc<bool, dynamic> {
  SaveRegistrosGeneralesUcImpl({
    required ListaVerificacionApiRepository repository,
  }) : _repository = repository;

  final ListaVerificacionApiRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  ) async =>
      await _repository.saveRegistrosGenerales(
        registroGeneral,
        userId,
        idSede,
      );
}
