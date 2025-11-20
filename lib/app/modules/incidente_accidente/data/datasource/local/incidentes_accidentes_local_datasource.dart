import 'package:safe2biz/app/modules/incidente_accidente/data/models/incidente_accidente_model.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';

abstract class IncidentesAccidentesLocalDatasource {
  Future<List<IncidenteAccidenteModel>> getIncidentesAccidentesFromStorage(
      String idSede);
  Future<IncidenteAccidenteModel> getIncidenteAccidenteFromStorage(String id);
  Future<bool> editIncidenteAccidenteFromStorage(
      IncidenteAccidente incidenteAccidente);
  Future<bool> editStatusIncidenteAccidenteFromStorage(int id, String status);
  Future<bool> saveIncidenteAccidenteStorage(
    IncidenteAccidente incidenteAccidente,
  );
  Future<bool> deleteAllIncidentesAccidentesStorage();
  Future<bool> deleteIncidenteAccidenteStorage(int id);
}
