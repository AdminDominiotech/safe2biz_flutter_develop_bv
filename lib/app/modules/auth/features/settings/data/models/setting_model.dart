import 'package:safe2biz/app/modules/auth/features/settings/domain/entities/entities.dart';

class SettingModel extends Setting {
  SettingModel({
    required String ip,
    required String nameCompany,
      required String arroba,
  }) : super(
    ip: ip,
    nameCompany: nameCompany,
      arroba: arroba
  );



  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    ip: json['ip'] ?? '',
    nameCompany: json['name_company'] ?? '',
    arroba: json['ARROBA_MOVIL'], // aquí se extrae el nuevo campo
  );

  Map<String, dynamic> toJson() => {
    'ip': ip,
    'name_company': nameCompany,
    'ARROBA_MOVIL': arroba,
  };

  SettingModel copyWith({
    String? ip,
    String? nameCompany,
    String? arroba,
  }) =>
      SettingModel(
        ip: ip ?? this.ip,
        nameCompany: nameCompany ?? this.nameCompany,
        arroba: arroba ?? this.arroba
      );
}
