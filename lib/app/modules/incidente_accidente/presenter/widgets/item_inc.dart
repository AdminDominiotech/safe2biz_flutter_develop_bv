import 'package:flutter/material.dart' hide Badge;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_permission/mobile_safe2bizapp_permission.dart';
import 'package:safe2biz/app/global/core/location_permission/location_permission_page.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/page/detail_inc_page.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/bloc/inc_bloc.dart';

class ItemINC extends StatelessWidget {
  const ItemINC({
    Key? key,
    required this.incidenteAccidente,
  }) : super(key: key);

  final IncidenteAccidente incidenteAccidente;

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
          //if (await AppLocationPermission.checkPermission()) {
          final result = await Nav.go(
            context,
            BlocProvider.value(
              value: context.read<INCBloc>(),
              child: DetailINCPage(
                incidenteAccidente: incidenteAccidente,
              ),
            ),
          );

          if (result != null && result as bool) {
            final idSede = context.read<INCBloc>().state.model.idSede;
            context.read<INCBloc>().add(InitEv(idSede: idSede));
          }
          /*} else {
            Nav.go(
              context,
              const LocationPermissionPage(),
            );
          }*/
        },
        splashColor: Colors.red,
        child: PhysicalModel(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              S2BRadius.xs,
            ),
          ),
          color: Colors.white,
          clipBehavior: Clip.none,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: S2BSpacing.sm,
              vertical: S2BSpacing.sm,
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    // Salud
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            child: TextLabel.h5(
                              _labelOrigen(incidenteAccidente.incTipoReporteNombre),
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                              color: S2BColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 4,),
                          Badge(
                            incidenteAccidente.incPotencialPerdidaNombre,
                            colorBackground: _colorNivelRiesgo(
                                incidenteAccidente.incPotencialPerdidaNombre),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),


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
                              incidenteAccidente.fbAreaNombre,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(
                              height: S2BSpacing.xs,
                            ),
                            TextLabel.small(
                              incidenteAccidente.descripcion,
                              color: S2BColors.silver,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextLabel.small(
                        '${incidenteAccidente.fecha}\n${incidenteAccidente.hora}',
                        color: S2BColors.primaryColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6,),
                const Divider(height: 4, color: Colors.grey,),
                SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    /*Button Por enviar / Enviado
                    Expanded(
                      flex: 3,
                      child: Badge(
                        _labelEstado(incidenteAccidente.estado),
                        colorBackground: _colorEstado(incidenteAccidente.estado),
                      ),
                    ),

                    */

                    Spacer(
                      flex: 7,
                    ),

                    //Upload / Delete
                    Expanded(
                      flex: 2,
                      child: incidenteAccidente.estado == '0'
                          ? InkWell(
                        onTap: () => _upload(context, incidenteAccidente), // Llamar a _upload cuando se toca el icono de subir
                        child: Icon(
                          FontAwesomeIcons.upload.data,
                          color: S2BColors.primaryColor,
                          size: 15,
                        ),
                      )
                          : InkWell(
                        onTap: () => _delete(context), // Llamar a _delete cuando se toca el icono de eliminar
                        child: Icon(
                          FontAwesomeIcons.trash.data,
                          color: S2BColors.dangerColor,
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
      ),
    );
  }

  String _labelOrigen(String tipoReporteNombre) {
    String label = '';
    if (tipoReporteNombre.isNotEmpty && tipoReporteNombre.length > 4) {
      label = tipoReporteNombre.substring(0, 5).toUpperCase();
    }

    return label;
  }

  Color _colorNivelRiesgo(String nivelRiesgo) {
    Color color;

    switch (nivelRiesgo.toLowerCase()) {
      case '0':
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



  void _delete(BuildContext context) {
    PopupMessage(
      context: context,
      title: 'Eliminar registro',
      bodyText: '¿Esta seguro que desea eliminar este registro?',
      isDismissible: false,
      onSucess: () async {
        context.read<INCBloc>().add(
              DeleteIncidenteAccidenteEv(
                incidenteAccidente: incidenteAccidente,
              ),
            );
        Nav.back(context);
      },
    );
  }

  void _upload(BuildContext context, IncidenteAccidente incidenteAccidente) {


    context.read<INCBloc>().add(
      UploadIncidentesAccidentesEv(
        incidentesAccidentes: [incidenteAccidente],
      ),
    );


  }



}



//  BAJO ->VERDE
// MEDIO ->AMARILLO
// ALTO -> ROJO
// EXTREMO->ROJO
