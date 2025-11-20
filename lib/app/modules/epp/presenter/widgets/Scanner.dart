
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_registro/components/scan_info_prod.dart';
import 'package:flutter_registro/database/database.dart';


bool isSwitched = false;
String scanBarcode = 'Desconocido';

class EscanerEquipo extends StatefulWidget {
  const EscanerEquipo({Key? key}) : super(key: key);

  @override
  State<EscanerEquipo> createState() => _EscanerEquipoState();
}

class _EscanerEquipoState extends State<EscanerEquipo> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: scanBarcodeNormal(),
      builder: (context, snapshot) {
        Container();
      },


    );

  }

  @override
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Error';
    }

    if (!mounted) return;
    setState(() {
      scanBarcode = barcodeScanRes;

      if (barcodeScanRes != "-1") {
        scanBarcode = barcodeScanRes;

        if (isSwitched != true) {
          sendProdInfo(context, scanBarcode.toString());
          Text("Exito");
          // showAlertUser(context, 'Exito', 3);
        } else {
          sendProdInfo(context, scanBarcode.toString());
          //showAlertProd(context, 'Exito', 3);

        }
      } else {
        scanBarcode = "Escaneo canceledo";
      };
    });
  }
}


void sendProdInfo(BuildContext context, String codigo) async{
  //sendInfoProduct
  SqlDb sqlDb = SqlDb();
  List<Map> datoEscaneadoProd = await sqlDb.getProduct(codigo);
  print(datoEscaneadoProd);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProductInfo(
        //Mandar  Empleado
        idEmp: idEmpleado,
        //Mandar info Producto
        idProd: datoEscaneadoProd.first["id"],
        codigo:  datoEscaneadoProd.first["codigo"],
        nombre:  datoEscaneadoProd.first["nombre"],
        marca: datoEscaneadoProd.first["marca"],
        descripcion: datoEscaneadoProd.first["descripcion"],
        caracteristicas: datoEscaneadoProd.first["caracteristicas"],
        foto: datoEscaneadoProd.first["foto"],
      ),),).then((_) => setState( (){       Navigator.pop(context); } ) //===>Actualizar estado despues de escanear un item
  );

}

*/