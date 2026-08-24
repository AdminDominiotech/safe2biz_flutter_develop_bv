import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';

import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/external/api/planes_accion_api.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/page/detail_sac_page.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/bloc/sac_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:safe2biz/app/modules/planes_accion/presenter/page/sac_page.dart';

import '../../../actos_condiciones_bot/presenter/page/actos_condiciones_detalle.dart';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';


class ItemSAC extends StatefulWidget {
  const ItemSAC({
    Key? key,
    required this.planAccion,
    this.onDeleted,
  }) : super(key: key);

  final PlanAccion planAccion;
  final void Function(String id)? onDeleted;

  @override
  State<ItemSAC> createState() => _ItemSACState();
}
String _normEstado(String? s) => (s ?? '').trim();

class _ItemSACState extends State<ItemSAC> {

  final PlanesAccionApi _api =
  PlanesAccionApi(dioMicroServices: DioMicroServices());


  bool _subiendo = false;
  bool _eliminando = false;
  bool _enviado = false;
  final authController = AuthController(sqlite: localSqliteInstance);
  final Dio _dio = DioMicroServices().msDio;


  @override
  void initState() {
    super.initState();
    _enviado = _normEstado(widget.planAccion.estado) == '1';
  }

  @override
  void didUpdateWidget(covariant ItemSAC oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.planAccion.id != widget.planAccion.id ||
        oldWidget.planAccion.estado != widget.planAccion.estado) {
      _enviado = _normEstado(widget.planAccion.estado) == '1';
    }
  }


  bool get _isUploaded => _enviado || _normEstado(widget.planAccion.estado) == '1';
  bool get _canUpload  => !_enviado && _normEstado(widget.planAccion.estado) == '0';

  String get _estado => (widget.planAccion.estado ?? '').trim();

  Widget _buildAccionBtn() {
    if (_isUploaded) {
      return IconButton(
        onPressed: _eliminando ? null : () => _onDelete(widget.planAccion),
        icon: _eliminando
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(FontAwesomeIcons.trash.data, color: Colors.red, size: 16),
        tooltip: 'Eliminar',
      );
    }
    if (_canUpload) {
      return IconButton(
        onPressed: _subiendo ? null : _uploadPlan,
        icon: _subiendo
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(FontAwesomeIcons.upload.data, color: Colors.indigo, size: 16),
        tooltip: 'Subir',
      );
    }
    return const SizedBox.shrink(); // ningún ícono para otros estados (vacío, null, "2", etc.)
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FRANJA IZQUIERDA
            Container(
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),

            // TARJETA
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                elevation: 2,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  onTap: () async {
                    await Nav.go(
                      context,
                      BlocProvider.value(
                        value: context.read<SACBloc>(),
                        child: DetailSACPage(planAccion: widget.planAccion),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado: Código + Fecha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.chevron_right_outlined, size: 8),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.planAccion.codigo.isNotEmpty
                                        ? widget.planAccion.codigo
                                        : 'Sin código',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),




                            Row(
                              children: [
                                Icon(Icons.calendar_month, size: 10,),
                                SizedBox(width: 1,),
                                Text(
                                  widget.planAccion.fechaOrigen.isNotEmpty
                                      ? widget.planAccion.fechaOrigen
                                      : '29/08/2025',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Divider(),


                        // Descripción
                        Text(
                          widget.planAccion.detalle.isNotEmpty
                              ? widget.planAccion.detalle
                              : 'Acción correctiva 1 - Comunicar',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),

                        const SizedBox(height: 15),


                        Row(
                          children: [
                            const Text(
                              'Verificador:       ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.planAccion.responsableVerificador.isNotEmpty
                                    ? widget.planAccion.responsableVerificador
                                    : ' - ',
                                style: const TextStyle(fontSize: 13, color: Colors.grey,fontWeight: FontWeight.bold, ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // NUEVA FILA: Generador
                        Row(
                          children: [
                            const Text(
                              'Responsable:   ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.planAccion.responsable.isNotEmpty
                                    ? widget.planAccion.responsable
                                    : 'verificador',
                                style: const TextStyle(fontSize: 13, color: Colors.grey,fontWeight: FontWeight.bold, ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        const Divider(),

                        // Parte inferior: Origen + Ícono
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  widget.planAccion.origen.isNotEmpty
                                      ? widget.planAccion.origen
                                      : 'Sin Origen',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),



                            Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: _buildAccionBtn(),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mapea el nivel de riesgo a un color
  Color _colorNivelRiesgo(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'bajo':
        return Colors.green;
      case 'medio':
        return Colors.yellow[700] ?? Colors.yellow; // un amarillo un poco más oscuro
      case 'alto':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }



  int daysBetween(DateTime from, String dateString) {
    try {
      final dateFormat = intl.DateFormat('yyyy-MM-dd');
      final to = dateFormat.parse(dateString);
      return to.difference(from).inDays;
    } catch (e) {
      debugPrint("Error parseando la fecha '$dateString': $e");
      return 0;
    }
  }



  Future<void> _uploadPlan() async {
    if (!mounted) return;
    setState(() => _subiendo = true);

    try {
      // 1) Credenciales del usuario
      final user = await authController.getUserFromStorage();
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('No hay sesión de usuario.')),
        );
        return;
      }

      // urlApp viene algo como "https://app.safe2biz.com/safe2biz"
      String baseApp = user.urlApp.trim();

      // 🔹 Normalizamos según el entorno
      if (baseApp.contains('app.safe2biz.com')) {
        // Producción: forzamos HTTPS
        if (baseApp.startsWith('http://')) {
          baseApp = baseApp.replaceFirst('http://', 'https://');
        } else if (!baseApp.startsWith('https://')) {
          baseApp = 'https://$baseApp';
        }
      } else if (baseApp.contains(':8083')) {
        // Ambiente legacy: mantenemos HTTP (para evitar TLS en 8084)
        if (baseApp.startsWith('https://')) {
          baseApp = baseApp.replaceFirst('https://', 'http://');
        } else if (!baseApp.startsWith('http://')) {
          baseApp = 'http://$baseApp';
        }
      } else {
        // Default: si no tiene esquema, asumimos https
        if (!baseApp.startsWith('http://') && !baseApp.startsWith('https://')) {
          baseApp = 'https://$baseApp';
        }
      }

      // Aseguramos slash final
      if (!baseApp.endsWith('/')) baseApp = '$baseApp/';

      // 2) Base absoluta con /ws/null/
      final absBase = '${baseApp}ws/null/';

      // 3) Headers requeridos por el backend
      final headers = <String, dynamic>{
        'userLogin':    '${user.userLogin}@${user.arroba}',
        'userPassword': user.password,
        'systemRoot':   user.enterprise,
        Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
        Headers.acceptHeader: Headers.jsonContentType,
      };

      final p = widget.planAccion;
      final body = {
        'sac_accion_correctiva_id': p.id,
        'fecha_eje'               : p.fechaEjecucion,
        'user_id'                 : '1',
        'obs_resp_corr'           : p.obsRespCorr,
        'evidencia'               : '${p.evidenciaNombre};${p.evidenciaRuta}',
      };

      // 4) Dio con followRedirects y validateStatus
      final dio = Dio(
        BaseOptions(
          baseUrl: absBase,
          connectTimeout:  30000,
          sendTimeout: 30000,
          receiveTimeout:  60000,
          followRedirects: true,
          // Acepta todo < 500; el manejo de error lo haces tú
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      dev.log('[UPLOAD] base=$absBase endpoint=pr_movil_ACC_Actualiza', name: 'ItemSAC');
      dev.log('[UPLOAD] headers={userLogin:${headers['userLogin']}, systemRoot:${headers['systemRoot']}}', name: 'ItemSAC');
      dev.log('[UPLOAD] body=$body', name: 'ItemSAC');

      // 5) Primer intento: x-www-form-urlencoded
      Response res = await dio.post(
        'pr_movil_ACC_Actualiza',
        data: body,
        options: Options(headers: headers),
      );

      // Si el server devuelve 410, reintentas como JSON (tu lógica actual)
      if (res.statusCode == 410) {
        final jsonHeaders = Map<String, dynamic>.from(headers)
          ..[Headers.contentTypeHeader] = Headers.jsonContentType;

        dev.log('[UPLOAD] 410 → retry JSON', name: 'ItemSAC');
        res = await dio.post(
          'pr_movil_ACC_Actualiza',
          data: body,
          options: Options(headers: jsonHeaders),
        );
      }

      dev.log('[UPLOAD] ← status=${res.statusCode} data=${res.data}', name: 'ItemSAC');

      if (!mounted) return;

      if (res.statusCode == 200) {
        setState(() => _enviado = true);

        Toast.show(
          description: 'Subido Correctamente',
          toastType: ToastType.success,
        );
      } else {
        // Algún código no-200: muestras error genérico
        Toast.show(
          description: 'Error al subir (código ${res.statusCode})',
          toastType: ToastType.error,
        );
      }
    } on DioError catch (e, s) {
      dev.log(
        '[UPLOAD][DioError] code=${e.response?.statusCode} url=${e.requestOptions.uri} body=${e.response?.data}',
        name: 'ItemSAC',
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        final msg = e.response?.data is Map && (e.response?.data['errors'] is List)
            ? (e.response!.data['errors'] as List).join(' | ')
            : e.message ?? 'Error de red';
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text('Error al subir: $msg')),
        );
      }
    } catch (e, s) {
      dev.log('[UPLOAD][ERR] $e', name: 'ItemSAC', error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _subiendo = false);
    }
  }

  Future<void> _onDelete(PlanAccion p) async {
    if (!mounted || _eliminando) return;
    setState(() => _eliminando = true);

    try {
      final db = await localSqliteInstance.database;
      final rows = await db.delete(
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        where: 'sac_accion_correctiva_id = ?',
        whereArgs: [p.id],
      );

      if (!mounted) return;

      if (rows > 0) {
        // 👇 tras borrar, fuerza que ya no se muestre el ícono de papelera
        setState(() => _enviado = false);


        // ✅ Toast de éxito
        Toast.show(description: 'Eliminado Correctamente', toastType: ToastType.success);

// espera un toque para que se vea el toast
        await Future.delayed(const Duration(milliseconds: 300));

// vuelve a pintar la página que contiene a SACBody
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) =>  SACPage()), // tu page que usa SACBody
        );



      } else {
        Toast.show(
          description: 'No se encontró el registro',
          toastType: ToastType.warning,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Toast.show(
        description: 'Error al eliminar: $e',
        toastType: ToastType.error,
      );
    } finally {
      if (!mounted) return;
      setState(() => _eliminando = false);
    }
  }



}


