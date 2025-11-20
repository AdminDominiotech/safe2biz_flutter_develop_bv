// Dart imports:
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data' as td;
// Package imports:
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app_infraestructure/device_info/device_info.dart';

// Project imports:
enum TypeSource { camera, gallery }

class AppController {
  // -------------------VARIABLES-------------------
  static int? _platformInt;
  static String? _modelDevice;
  static String? _versionApp;

  // -------------------------------------------------------
  // -------------------IMAGEN PICKER-------------------
  Future<File?> loadImageDevice(TypeSource typeSource) async {
    try {
      var _picker = ImagePicker();
      final source = typeSource == TypeSource.camera
          ? ImageSource.camera
          : ImageSource.gallery;
      final xFile = await _picker.pickImage(source: source);
      if (xFile != null) {
        final image = File(xFile.path);

        // final zipImage = await Utils.compressImage(image);
        // final newImage = zipImage ?? image;
        // final base64 = await Utils.fileToBase64(newImage);
        // final filename =
        //     '${DateFormat('yyyyMMddHms').format(DateTime.now())}-min.jpg';
        // return ImgResponse(file: newImage, base64: base64!, nameFile: filename);
        return image;
      }
    } catch (e) {
      print('😊 $e');
      // _picker.retrieveLostData();
      throw LocalException(message: e.toString());
    }
    return null;
  }

  Future<ImgResponse> transformImage(dynamic input) async {
    try {
      // 1) Comprimir si te llega un File (si tu Utils la necesita)
      final dynamic compressed = input is File
          ? await Utils.compressImage(input) // puede devolver XFile/File/Uint8List/null
          : input;

      // 2) Normalizar a bytes sin castear a File
      td.Uint8List bytes;

      if (compressed == null) {
        // sin compresión → tomar bytes del input original
        if (input is File) {
          bytes = await input.readAsBytes();
        } else if (input is XFile) {
          bytes = await input.readAsBytes();
        } else if (input is String) {
          // ruta
          bytes = await File(input).readAsBytes();
        } else if (input is td.Uint8List) {
          bytes = input;
        } else if (input is List<int>) {
          bytes = td.Uint8List.fromList(input);
        } else {
          throw Exception('Tipo no soportado: ${input.runtimeType}');
        }
      } else if (compressed is File) {
        bytes = await compressed.readAsBytes();
      } else if (compressed is XFile) {
        bytes = await compressed.readAsBytes();
      } else if (compressed is td.Uint8List) {
        bytes = compressed;
      } else if (compressed is List<int>) {
        bytes = td.Uint8List.fromList(compressed);
      } else if (compressed is String) {
        // ruta a archivo
        bytes = await File(compressed).readAsBytes();
      } else {
        throw Exception('Tipo no soportado tras compresión: ${compressed.runtimeType}');
      }

      final String b64 = base64Encode(bytes);
      final String filename = '${DateFormat('yyyyMMddHms').format(DateTime.now())}-min.jpg';
      return ImgResponse(base64: b64, nameFile: filename);
    } catch (e) {
      // aquí puedes loguear e if needed: debugPrint('$e');
      throw LocalException(message: e.toString());
    }
  }

  // Future<ImgResponse?> loadImageDevice(TypeSource typeSource) async {
  //   try {
  //     var _picker = ImagePicker();
  //     final source = typeSource == TypeSource.camera
  //         ? ImageSource.camera
  //         : ImageSource.gallery;
  //     final xFile = await _picker.pickImage(source: source);
  //     if (xFile != null) {
  //       final image = File(xFile.path);

  //       final zipImage = await Utils.compressImage(image);
  //       final newImage = zipImage ?? image;
  //       final base64 = await Utils.fileToBase64(newImage);
  //       final filename =
  //           '${DateFormat('yyyyMMddHms').format(DateTime.now())}-min.jpg';
  //       return ImgResponse(file: newImage, base64: base64!, nameFile: filename);
  //     }
  //   } catch (e) {
  //     throw LocalException(message: e.toString());
  //   }
  //   return null;
  // }

  // -------------------------------------------------------
  // -------------------DEVICE INFORMATION------------------
  int get getPlatformInt => _platformInt!;
  String get getModelDevice => _modelDevice!;
  String get getVersionApp => _versionApp!;

  Future<void> loadDevice() async {
    if (_platformInt == null || _modelDevice == null || _versionApp == null) {
      final dinfo = Device.info;
      _platformInt = dinfo.getPlatformInt;
      _modelDevice = await dinfo.getModelDevice();
      _versionApp = await dinfo.getVersion();
    }
  }
}

class ImgResponse {
  const ImgResponse({
    required this.base64,
    required this.nameFile,
  });
  final String base64;
  final String nameFile;
}
