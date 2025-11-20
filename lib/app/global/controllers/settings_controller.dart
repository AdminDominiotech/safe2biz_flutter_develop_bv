// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/auth/features/settings/data/models/setting_model.dart';
import 'package:safe2biz/app/modules/auth/features/settings/domain/entities/entities.dart';

// Project imports:
class SettingsController {
  SettingsController({
    required LocalSqlite sqlite,
    //   required SaveSettigLocalUcImpl saveSettigLocalUc,
    // required DeleteSettigLocalUcImpl deleteSettigLocalUc})
  })  : _sqlite = sqlite,
  // _deleteSettigLocalUc = deleteSettigLocalUc,
  //   _saveSettigLocalUc = saveSettigLocalUc,
        super();
  LocalSqlite get sqlite => _sqlite;

  final LocalSqlite _sqlite;
  // final DeleteSettigLocalUcImpl _deleteSettigLocalUc;
  // final SaveSettigLocalUcImpl _saveSettigLocalUc;

  final _setting = ValueNotifier<Setting?>(null);


  String? _ip;
  String? _nameCompany;
  String? _nameArroba;

  Setting? get setting => _setting.value;
  String get getIP => _setting.value!.ip;

  Future<void> delete() async {
    try {
      final db = await _sqlite.database;

      await db.delete(LocalSqlite.TABLE_SETTINGS);
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }


  Future<bool> save() async {
    if (_ip == null || _nameCompany == null || _nameArroba == null) {
      throw const LocalFailure(message: 'Datos incompletos: IP, empresa o arroba no definidos');
    }

    await delete();
    try {
      final db = await _sqlite.database;

      // Crea la instancia internamente con los valores definidos previamente
      final newSetting = Setting(ip: _ip!, nameCompany: _nameCompany!, arroba: _nameArroba!);

      final result = await db.insert(
        LocalSqlite.TABLE_SETTINGS,
        {
          'ip': newSetting.ip,
          'name_company': newSetting.nameCompany,
          'ARROBA_MOVIL': newSetting.arroba,
        },
      );

      print('[Controller] Guardando config: $_ip, $_nameCompany, $_nameArroba');


      // Muestra el contenido actual de la tabla
      final allRecords = await db.query(LocalSqlite.TABLE_SETTINGS);
      print("Contenido completo de la tabla SETTINGS:");
      for (var record in allRecords) {
        print(record);
      }

      if (result > 0) {
        _setting.value = newSetting;
        return true;
      } else {
        throw const LocalFailure(message: 'Error al guardar ajustes');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }


  }

  Future<bool> saveS2B() async {
    await delete();
    try {
      final db = await _sqlite.database;

      final result = await db.insert(
        LocalSqlite.TABLE_SETTINGS,
        {'ip': 'https://app.safe2biz.com/safe2biz', 'name_company': 'safe2biz', 'ARROBA_MOVIL': 's2buenaventura'},
      );

      if (result > 0) {
        print("True");
        return true;
      } else {
        throw const LocalFailure(message: 'Error al guardar ajustes');
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }



  void setValues(String ip, String nameCompany, String arroba) {
    _ip = ip;
    _nameCompany = nameCompany;
    _nameArroba = arroba;
  }

  Future<SettingModel?> getSettingFromStorage() async {
    try {
      final db = await _sqlite.database;
      final result = await db.query(LocalSqlite.TABLE_SETTINGS);



      if (result.isNotEmpty) {
        final newSetting = List.from(result)
            .map((item) => SettingModel.fromJson(item))
            .toList()
            .first;
        _setting.value = newSetting;
        return newSetting;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      throw AppException(message: stackTrace.toString());
    }
  }
}