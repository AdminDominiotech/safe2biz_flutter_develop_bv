import 'package:equatable/equatable.dart';

class Setting extends Equatable {
  const Setting({
    required this.ip,
    required this.nameCompany,
    required this.arroba,
  });

  final String ip;
  final String nameCompany;
  final String arroba; // Nuevo campo opcional

  @override
  List<Object?> get props => [ip, nameCompany, arroba];

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      ip: json['ip'] as String,
      nameCompany: json['name_company'] as String,
      arroba: json['ARROBA_MOVIL'] as String, // Aquí se agrega
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'name_company': nameCompany,
      'ARROBA_MOVIL': arroba,
    };
  }
}
