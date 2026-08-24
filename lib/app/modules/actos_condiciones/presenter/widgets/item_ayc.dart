import 'package:flutter/material.dart' hide Badge;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_permission/mobile_safe2bizapp_permission.dart';
import 'package:safe2biz/app/global/core/location_permission/location_permission_page.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/detail_acto_condicion/presenter/page/detail_ayc_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/bloc/ayc_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


class ItemAyC extends StatelessWidget {
  const ItemAyC({
    Key? key,
    required this.actoCondicion,
  }) : super(key: key);

  final ActoCondicion actoCondicion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: S2BSpacing.xs,
        vertical: S2BSpacing.sm,
      ).copyWith(
        top: S2BSpacing.zero,
      ),
      child: InkWell(
        onTap: () async {
          if (await AppLocationPermission.checkPermission()) {
            await Nav.go(
              context,
              BlocProvider.value(
                value: context.read<AyCBloc>(),
                child: DetailAyCPage(
                  actoCondicion: actoCondicion,
                ),
              ),
            );
          } else {
            Nav.go(
              context,
              const LocationPermissionPage(),
            );
          }
        },
        splashColor: Colors.red,
        child: PhysicalModel(
          borderRadius: const BorderRadius.all(
            Radius.circular(S2BRadius.xs),
          ),
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          child: IntrinsicHeight(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Franja de estado izquierda
              Container(
                width: 6,
                color: actoCondicion.estado == '0'
                    ? const Color(0xFFE53935)
                    : const Color(0xFF43A047),
              ),
              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: S2BSpacing.sm,
                    vertical: S2BSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Origen
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                TextLabel.h5(
                                  _labelOrigen(actoCondicion.origen),
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.center,
                                  color: S2BColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),

                          // Descripción y Empresa
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: S2BSpacing.xs,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabel.labelText(
                                    actoCondicion.fbAreaNombre,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: S2BSpacing.xs),
                                  TextLabel.small(
                                    actoCondicion.descripcion,
                                    color: S2BColors.silver,
                                  ),
                                  const SizedBox(height: S2BSpacing.xs),
                                  Text(
                                    actoCondicion.fbEmpresaEspecializadaNombre,
                                    style: const TextStyle(
                                      color: S2BColors.blue,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Fecha y Hora
                          Expanded(
                            flex: 3,
                            child: TextLabel.small(
                              '${actoCondicion.fecha}\n${actoCondicion.hora}',
                              color: S2BColors.primaryColor,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Divider(height: 4, color: Colors.grey),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(flex: 9),

                          // Botón de estado
                          Expanded(
                            flex: 3,
                            child: actoCondicion.estado == '0'
                                ? InkWell(
                                    onTap: () =>
                                        _upload(context, actoCondicion),
                                    child: Icon(
                                      FontAwesomeIcons.upload.data,

                                      size: 15,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () => _delete(context),
                                    child: Icon(
                                      FontAwesomeIcons.trash.data,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }



  String _labelOrigen(String origen) {
    final newOrigen = origen == 'A' ? 'ACTO' : 'ACTO';

    return newOrigen;
  }

  Color _colorNivelRiesgo(String nivelRiesgo) {
    Color color;

    switch (nivelRiesgo.toLowerCase()) {
      case 'bajo':
        color = S2BColors.green;
        break;
      case 'medio':
        color = S2BColors.yellow;
        break;
      case 'alto':
        color = S2BColors.dangerColor;
        break;
      case 'extremo':
        color = S2BColors.dangerColor;
        break;
      default:
        color = S2BColors.dangerColor;
    }

    return color;
  }
  Color _colorEstado(String nivelRiesgo) {
    Color color;

    switch (nivelRiesgo.toLowerCase()) {
      case '0':
        color = Color(0XFFF67280);
        break;
      case '1':
        color = Color(0XFFA4D998);
        break;

      default:
        color = S2BColors.dangerColor;
    }

    return color;
  }

  String _labelEstado(String estado) {
    switch (estado) {
      case '0':
        return 'Por Enviar';
      case '1':
        return 'Enviado';
      default:
        return 'Desconocido'; // o alguna otra etiqueta por defecto
    }
  }

  void _upload(BuildContext context, ActoCondicion actoCondicion) {
    // Aquí se crea una lista que solo contiene el acto o condición que queremos subir
    List<ActoCondicion> actosCondicionesParaSubir = [actoCondicion];

    // Agregamos el evento para subir el acto o condición
    context.read<AyCBloc>().add(
      UploadActosCondicionesEv(actosCondiciones: actosCondicionesParaSubir),
    );

    // Muestra un snackbar o un mensaje para indicar que se está subiendo el acto o condición


    // Aquí puedes manejar cualquier lógica adicional después de la subida, como actualizar la interfaz de usuario
  }


  void _delete(BuildContext context) {
    PopupMessage(
      context: context,
      title: 'Eliminar registro',
      bodyText: '¿Esta seguro que desea eliminar este registro?',
      isDismissible: false,
      onSucess: () async {
        context.read<AyCBloc>().add(
              DeleteActoCondicionEv(
                actoCondicion: actoCondicion,
              ),
            );
        Nav.back(context);
      },
    );
  }
}

//  BAJO ->VERDE
// MEDIO ->AMARILLO
// ALTO -> ROJO
// EXTREMO->ROJO
