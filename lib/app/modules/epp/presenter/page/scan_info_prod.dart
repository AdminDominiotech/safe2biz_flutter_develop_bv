import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:intl/intl.dart' as init;
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/widgets/FechaHora.dart';
import 'package:safe2biz/app/modules/epp/presenter/widgets/cantidad_widget.dart';
import 'package:safe2biz/app/modules/epp/presenter/widgets/fechaFiltro.dart';




bool visible = true;

class ProductInfo extends StatefulWidget {

  //Opciones visibles (cantidad)
  final String? isVisible;
  //Varialbe ID Empleado
  final int? idEmp, tipo_equipo_id;
  //Variables producto
  final int? idProd, equipo_id, producto_id, tiempo_recambio, identify;
  final double? costo;
  final String? proveedor, observacion, codigo, nombre, marca, modelo, descripcion, foto_prod, fechaEntrega, horaEntrega, anho, tipo_equipo, tipo_equipo_codigo, equipo_codigo, equipo_nombre;

  //Variables de entrada

   const ProductInfo({Key? key, this.idProd, this.nombre,  this.marca, this.descripcion, this.codigo, this.idEmp, this.isVisible, this.foto_prod, this.fechaEntrega, this.horaEntrega, this.tipo_equipo, this.anho, this.tipo_equipo_id, this.tipo_equipo_codigo, this.equipo_codigo, this.equipo_nombre, this.tiempo_recambio, this.equipo_id, this.producto_id, this.modelo, this.costo, this.identify, this.proveedor, this.observacion}) : super(key: key);


  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {


  bool _showImage = true;

  void _handleImageFound(bool found) {
    print("Imagen encontrada: $found"); // Imprimir el resultado del callback
    setState(() {
      _showImage = found;
    });
  }





  final List<String> _extensions = ['png', 'jpg', 'jpeg', 'jfif', 'webp'];
  String? _finalUrl;

  final List<String> items = [
    'Nuevo',
    'Deterioro',
    'Perdida',
    'Renovacion',
   ].toList();

  String? selection = null;
  String? fotoProd;

  String? obs;

  String? fecha;
  void initState(){

    obs = widget.observacion;
    if(obs == '' || obs == 'null' || obs == null){
      obs = 'No se registran observaciones.';
    }

     fotoProd = widget.foto_prod;

    super.initState();
  }



  //Expandir Descripcion
  final ExpandableController _expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {

    if(fotoProd == null || fotoProd == ''){
      fotoProd = 'productoDefault.png';
    }
    print("El valor de la foto es ----> $fotoProd");


    //Motivo de Entrega
    final dropdownMenuOptions = items
        .map((String item) =>
    new DropdownMenuItem<String>(value: item, child: new Text(item))
    ).toList();

    SqlDb sqlDb = SqlDb();     //SQLite Conexion
    int _currentIntValue = 10;
    int _currentHorizontalIntValue = 10;
    int idEmpleado;
    int idProducto;
   // int cantidad = 1;
    String estado = "0";

    if(widget.isVisible == "0"){
      visible = false;
    }
    else{
      visible = true;
    }





    /*
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, String>{}) as Map;
    final cod = arguments['codigo'];
    final nombre = arguments['nombre'];
    final marca = arguments['marca'];
    final descripcion = arguments['descripcion'];
    final caracteristicas = arguments['caracteristicas'];
    final foto = arguments['foto'];Implementar lector de escánera
*/

    return Scaffold(
      //  appBar: AppBar(title: Text(""), backgroundColor: Colors.transparent, elevation: 0,),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(

              child: Column(
                  children: [
                    //FOTO PRODUCTO
                    Container(
                      width:MediaQuery.of(context).size.width*0.98,
                      height: 100,
                      color: Colors.white,
                      child:                  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 12.0),
                            child: IconButton(onPressed: (){

                              Future.delayed(Duration(milliseconds: 10), () {
                                Navigator.pop(context);
                              }).then((value) => setState((){}));

                            }, icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),


                    /*
                    Container(
                      //fixme: implementar back button
                      margin: EdgeInsets.only(bottom: 15.0),
                              child: Image.asset ('assets/images/$fotoProd', fit: BoxFit.fill, width: MediaQuery.of(context).size.width*0.8, height: 220,), //fit = ajustar tamaño
                    ),
                    */


                                 _showImage
                            ? Container(
                            margin: EdgeInsets.only(bottom: 15.0),
                          child: DynamicImageLoader(
                            imageUrlBase: "https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD",
                            imageCode: '5600_${widget.producto_id}_${widget.codigo}',
                            onImageFound: _handleImageFound,
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 220,
                        )
                            : SizedBox.shrink(),


                    SizedBox(height: 5,),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 20.0),
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                        child: Text("${widget.nombre}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24)),
                        ),
                      ),
                    ),

                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                       child: Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("${widget.marca} - ${widget.modelo}", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff09357E), fontSize: 16)),
                        ),
                    ),
                     ),
                    Divider(height: 18, thickness: 1,),

                    //Fecha Vigencia

                   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(

                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.arrow_right),
                                              Text("Descripción", style: TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          SizedBox(height: 8,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width*0.80,
                                              child: Column(
                                                children: [
                                                Text("${widget.descripcion}", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14, height: 1.5)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.arrow_right),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
                                          child: Text("Observación", style: TextStyle(fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 25,),
                                                Text("${obs}", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14, height: 1.5)),
                                              ],
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
                        ],
                      ),


                    SizedBox(height: 10,),

                    Divider(height: 10, thickness: 1,),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_right),
                          Text("Entrega", style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),



                    Visibility(
                      visible: visible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric (horizontal: 32.0),
                        child: Container(
                          height: 55,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              label: Text('Motivo de entrega',  style: TextStyle(color: Colors.grey),),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff09357E)),
                              ),

                            ),
                            value: selection, style: TextStyle(fontSize: 14, color: Colors.black),
                            items: dropdownMenuOptions,
                            onChanged: (value) {
                              setState(() => selection = value);
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    Visibility(
                        visible: visible,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                child: Align(
                                    child: Row(children: [

                                      Column(
                                        children: [

                                          Row(
                                            children: [
                                              Text(" Cantidad:   ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                            ],
                                          ),
                                        ],
                                      ),
                                  //    fechaFiltro(),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          cantidadProd(),
                                        ],
                                      ),
                                    ],
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),





/*
                    Visibility(
                      visible: visible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 8.0),
                        child:
                      ),
                    ),


 */
                    SizedBox(height: 10,),






                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          /* CARACTERISITICAS PROD
                          Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("${widget.caracteristicas}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15, height: 1.5)),
                            ),
                          ),
                           */

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: visible,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width*0.89,
                              child: ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff00297B)
                                  ),

                                  onPressed: () async {

                                    if(selection == null || selection == ''){



                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        headerAnimationLoop: false,
                                        showCloseIcon: true,
                                        closeIcon: const Icon(Icons.close),
                                        title: 'Error',
                                        desc:
                                        'Seleccione el motivo de entrega.',
                                        btnCancelOnPress: () {},
                                        onDismissCallback: (type) {
                                          debugPrint('Dialog Dismiss from callback $type');
                                        },
                                        btnOkOnPress: () async{


                                        },
                                      ).show();


                                    }
                                    else{


                                      print("Actualizacion...");

                                      int response = await sqlDb.insertData("INSERT INTO 'producto_empleado_mina' "
                                          "('id_empleado',                     'id_producto',            'cantidad',  'estado_subido', 'fecha_entrega',            'hora_entrega',          'tipo_equipo_nombre',           'anho',                           'motivo') VALUES "
                                          "('${(widget.idEmp)!.toInt()}', '${(widget.idProd)!.toInt()}', '$cantidad', 'En Registro', '${widget.fechaEntrega}', '${widget.horaEntrega}', '${widget.tipo_equipo}', '${(widget.fechaEntrega)?.substring(0,4)}', '$selection')");
                                      print(response);

                                      print("Año producto ---> ${(widget.fechaEntrega)?.substring(0,4)}");



                                      //Insertamos valores en la tabla producto_empleado
                                      // cant_dias_vigente = fecha entrega - fecha vigencia



                                      fecha = widget.fechaEntrega;
                                      int? recambio = widget.tiempo_recambio;

                                      DateTime dt1 = init.DateFormat("yyyy/MM/dd").parse(fecha!);


                             //         DateTime dt1 = DateTime.parse(fecha!);


                                      var date = DateTime(dt1.year, dt1.month, dt1.day + recambio!);
                                      String fechaVigencia = date.toIso8601String().split("T")[0];


                                      print("formattedDate  ====> $fechaVigencia" );

                                      //Agregar formattedDate



                                      //epp_entrega_detalle
                                      int responseEntregaDetalle = await sqlDb.insertData("INSERT INTO 'EntregaDetalleEpp' "
                                          " ('id_emp',           'hora_entrega',          'identify',                    'epp_entrega_id',   'epp_ficha_entrega_id',       'epp_tipo_equipo_id',               'tipo_equipo_codigo',                          'tipo_equipo_nombre',                  'epp_equipo_id',             'equipo_codigo',                       'equipo_nombre',             'cantidad',            'epp_producto_id',             'producto_codigo',               'producto_marca',              'producto_modelo',              'producto_costo',      'epp_motivo_entrega_id',      'tiempo_recambio',                              'flag_pertenece_rol',        'fecha_entrega',           'fecha_fin_vigencia',        'cantidad_dias_vigente',               'flag_uso',          'estado_vigencia',    'codigo_almacen_entrega',          'epp_almacen_temp_id',      'fb_uea_pe_id',         'dni_empleado') VALUES "
                                          " ('${widget.idEmp}',   '${horaEntrega}',    '${widget.identify}',                   '1',                      '1',                     '${widget.tipo_equipo_id}',    '${widget.tipo_equipo_codigo}',              '${widget.equipo_nombre}',            '${widget.equipo_id}',             '${widget.equipo_codigo}',      '${widget.nombre}',           '${cantidad}',        '${widget.producto_id}',         '${widget.codigo}',              '${widget.marca}',            '${widget.modelo}',           '${widget.costo}',            '2',                     '${widget.tiempo_recambio}',                            '0',                 '${widget.fechaEntrega}',      '${fechaVigencia}',                        '0',                         '1',                       '1',                'ENT-TEMP-002',                        '2',                     '1',                   '41695307'  ) ");
                                      print(responseEntregaDetalle);



                                      Navigator.pop(context);
                                      setState(() {});

                                    }



                                 //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListaPersonal()));
                                  },
                                  child: Text("Agregar Equipo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(height: 1, thickness: 1, ),
                    ),

                    Visibility(
                      visible: false,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 0.0),
                          child:
                              Column(
                                children: [
                                  Text("Código del producto", style: TextStyle(color: Colors.grey),),
                                  SizedBox(height: 5,),

                                  /*
                                  BarCodeImage(
                                      params: Code93BarCodeParams (
                                        "${widget.codigo}",
                                        withText: true,
                                      )
                                  ),
                                  */
                                ],
                              ),

                        ),
                      ),
                    ),
                  ]
              )
          ),
        )
    );
  }



}

/*
class BarCodeItem {
  String description;
  BarCodeImage image;
  BarCodeItem({
    required this.image,
    required this.description,
  });
}
*/




class DynamicImageLoader extends StatefulWidget {
  final String imageUrlBase;
  final String imageCode;
  final Function(bool) onImageFound;
  const DynamicImageLoader({
    Key? key,
    required this.imageUrlBase,
    required this.imageCode, required this.onImageFound,
  }) : super(key: key);

  @override
  _DynamicImageLoaderState createState() => _DynamicImageLoaderState();
}

class _DynamicImageLoaderState extends State<DynamicImageLoader> {
  bool _imageFound = false; // Nuevo estado para rastrear si se encontró una imagen

  final List<String> _extensions = ['png', 'jpg', 'jpeg', 'gif'];
  String? _finalUrl;

  @override
  void initState() {
    super.initState();
    _findImage();
  }

  Future<void> _findImage() async {
    bool found = false;
    for (var ext in _extensions) {
      String testUrl = "${widget.imageUrlBase}/${widget.imageCode}.$ext";
      print("Probando URL: $testUrl");  // Imprimir la URL para verificar

      if (await _checkImage(testUrl)) {
        setState(() {
          _finalUrl = testUrl;
          _imageFound = true;
          found = true;
        });
        break;
      }
    }

    if (!found) {
      setState(() {
        _imageFound = false;
      });
      widget.onImageFound(false); // Llama al callback solo si ninguna imagen fue encontrada
    }
  }



  Future<bool> _checkImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      print("Código de estado para $url: ${response.statusCode}"); // Imprimir el código de estado
      return response.statusCode == 200;
    } catch (e) {
      print("Error al verificar $url: $e"); // Imprimir cualquier error
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return _imageFound
        ? Image.network(_finalUrl!, fit: BoxFit.fill, width: MediaQuery.of(context).size.width * 0.8, height: 220)
        : SizedBox.shrink(); // Utiliza SizedBox.shrink() para que no ocupe espacio
  }


}




