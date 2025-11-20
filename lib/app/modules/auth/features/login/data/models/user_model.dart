// ignore: must_be_immutable
import 'package:safe2biz/app/modules/auth/features/login/data/models/acceso_model.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/entities/entities.dart';

// ignore: must_be_immutable
class UserModel extends User {
  UserModel({
    required String uuid,
    required String name,
    required String code,
    required String userLogin,
    required String enterprise,
    required String password,
    required String fbEmpleadoId,
    required String urlExt,
    required String urlApp,
    required String arroba,
    required List<Acceso> accesos,
  }) : super(
          uuid: uuid,
          name: name,
          code:code,
          userLogin: userLogin,
          enterprise: enterprise,
          password: password,
          fbEmpleadoId: fbEmpleadoId,
          urlExt: urlExt,
          urlApp: urlApp,
          arroba: arroba,
          accesos: accesos,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uuid: '${json['SC_USER_ID'] ?? ''}',
        name: json['nombre_empleado'] ?? '',
        code: json['CODE'] ?? '',
        userLogin: json['USER_LOGIN'] ?? '',
        enterprise: json['ENTERPRISE'] ?? '',
        password: json['userPassword'] ?? '',
        fbEmpleadoId: '${json['fb_empleado_id'] ?? ''}',
        urlExt: json['URL_EXT'] ?? '',
        urlApp: json['URL_APP'] ?? '',
        arroba: json['ARROBA_MOVIL'] ?? '',
        accesos: AccesoModel.accesosFromJson(json['ACCESOS'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'SC_USER_ID': uuid,
        'nombre_empleado': name,
        'CODE': code,
        'USER_LOGIN': userLogin,
        'ENTERPRISE': enterprise,
        'userPassword': password,
        'fb_empleado_id': fbEmpleadoId,
        'URL_EXT': urlExt,
        'URL_APP': urlApp,
        'ARROBA_MOVIL': arroba,
        'ACCESOS': accesos,
      };

  static UserModel castEntity(User user) => user as UserModel;

  UserModel copyWith({
    String? uuid,
    String? name,
    String? code,
    String? userLogin,
    String? enterprise,
    String? password,
    String? fbEmpleadoId,
    String? urlExt,
    String? urlApp,
    String? arroba,
    List<Acceso>? accesos,
  }) =>
      UserModel(
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        code: code ?? this.code,
        userLogin: userLogin ?? this.userLogin,
        enterprise: enterprise ?? this.enterprise,
        password: password ?? this.password,
        fbEmpleadoId: fbEmpleadoId ?? this.fbEmpleadoId,
        urlExt: urlExt ?? this.urlExt,
        urlApp: urlApp ?? this.urlApp,
        arroba: arroba ?? this.arroba,
        accesos: accesos ?? this.accesos,
      );
}
