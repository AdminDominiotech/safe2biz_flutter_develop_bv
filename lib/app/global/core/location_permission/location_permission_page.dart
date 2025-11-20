import 'package:flutter/material.dart';
import 'package:mobile_safe2bizapp_permission/mobile_safe2bizapp_permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(
        'Solicitud de permisos',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              width: 54,
              height: 54,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color(0x4d52b9a5),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Image(
                width: 54,
                height: 54,
                image: AssetImage(
                  UiValues.markerIconPng,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextLabel.h6(
            '¡Usaremos tu ubicación!',
            textAlign: TextAlign.center,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(
            height: 30,
          ),
          TextLabel.labelText(
            'Permite que S2Biz conozca tu ubicación solo cuando realizas el registro de nueva información.\n\nS2Biz usará tu ubicación para obtener tu ubicación actual',
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 15,
          ),
          BtnDefault(
            'Verificar permisos',
            onTap: () => requestLocationAlwaysPermission(context),
          ),
          const SizedBox(
            height: 15,
          ),
          TextLabel.small(
            'Si marcaste denegar y no volver a preguntar, debes asignar manualmente el permiso de ubicación desde la configuración de tu teléfono.',
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> requestLocationAlwaysPermission(BuildContext context) async {
    if (await Permission.location.isPermanentlyDenied ||
        await Permission.locationAlways.isPermanentlyDenied) {
      await AppLocationPermission.requestPermission().then(
        (value) async {
          if (!await AppLocationPermission.checkPermission()) {
            await openAppSettings();
          }
        },
      );
    } else {
      var hasPermissions = await AppLocationPermission.checkPermission();
      var isEnabled = await AppLocationPermission.checkServiceEnabled();

      if (hasPermissions && isEnabled) {
        if (await AppLocationPermission.checkIfIsMocked()) {
          Toast.show(
            description:
                'Por favor comunicate con tu administrador y enviale este pantallazo',
            toastType: ToastType.error,
          );
        } else {
          Nav.back(context);
        }
      } else {
        if (!hasPermissions) {
          await AppLocationPermission.requestPermission().then(
            (value) async {
              if (!await AppLocationPermission.checkPermission()) {
                await openAppSettings();
              }
            },
          );
        } else if (!isEnabled) {
          await AppLocationPermission.requestLocationService();
        }
      }
    }
    if (await AppLocationPermission.checkPermission()) {
      Toast.show(
        description: 'Permisos aceptados exitosamente',
        toastType: ToastType.success,
      );
    } else {
      Toast.show(
        description:
            'Por favor para continuar navegando en la aplicación debe aceptar los permisos',
        toastType: ToastType.error,
      );
    }
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    if (await Permission.location.isPermanentlyDenied) {
      await AppLocationPermission.requestLocationPermission().then(
        (value) async {
          if (value != PermissionStatus.granted &&
              !await AppLocationPermission.checkLocationPermission()) {
            await openAppSettings();
          }
        },
      );
    } else {
      var hasPermissions =
          await AppLocationPermission.checkLocationPermission();
      var isEnabled = await AppLocationPermission.checkServiceEnabled();

      if (hasPermissions && isEnabled) {
        if (await AppLocationPermission.checkIfIsMocked()) {
          Toast.show(
            description:
                'Por favor comunicate con tu administrador y enviale este pantallazo',
            toastType: ToastType.error,
          );
        } else {
          Nav.back(context);
        }
      } else {
        if (!hasPermissions) {
          await AppLocationPermission.requestLocationPermission().then(
            (value) async {
              if (value != PermissionStatus.granted &&
                  !await AppLocationPermission.checkLocationPermission()) {
                await openAppSettings();
              }
            },
          );
        } else if (!isEnabled) {
          await AppLocationPermission.requestLocationService();
        }
      }
    }
  }
}
