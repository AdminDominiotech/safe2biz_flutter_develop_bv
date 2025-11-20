import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/sedes/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/data/models/models.dart';

class SedeApi implements SedeApiDatasource {
  SedeApi({required this.dioMicroServices});
  final DioMicroServices dioMicroServices;

  @override
  Future<List<SedeModel>> getSedesFromApi(String userId) async {
    final result = await dioMicroServices.msDio.post(
      '/pr_ws_fb_uea',
      queryParameters: {
        'sc_user_id': userId,
      },
      // options: Options(
      //   headers: {
      //     'userLogin': 'cesar.cueva@safe2biz_demo',
      //     'userPassword': '4321',
      //     'systemRoot': 'safe2biz',
      //   },
      // ),
    );
    if (result.statusCode == 200) {
      final data = result.data['data'];

      final companies =
          List.from(data).map((item) => SedeModel.fromJson(item)).toList();

      return companies;
    } else {
      throw ServerException(
        statusCode: result.statusCode,
      );
    }
  }
}
