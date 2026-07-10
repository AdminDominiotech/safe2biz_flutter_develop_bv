import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';

import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/actos_condiciones_bot/presenter/page/actos_condiciones_detalle.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_body.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';

import '../../../../global/controllers/auth_controller.dart';

class AYC_Bot extends StatefulWidget {



  final String? sede;
  const AYC_Bot({Key? key, this.sede}) : super(key: key);
  @override
  State<AYC_Bot> createState() => _AYC_BotState();
}


final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

class _AYC_BotState extends State<AYC_Bot> {

  int? sumaRojo;
  int? sumaNaranja;

  @override
  void initState(){
    super.initState();
    print("SEDE --> ${widget.sede}");
    _asyncMethod();
  }

  _asyncMethod() async {
  }

  @override
  Widget build(BuildContext context) {

    //Colores estado
    Color? colorEstado;
    String? ambitoImg;
    //Cantidad de incidentes por color de estado
    int cantRojo = 0;
    int cantNaranja = 0;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Actos y Condiciones BOT", style: TextStyle(fontSize: 16, color: Colors.white),),
            backgroundColor: S2BColors.primaryColor,
            elevation: 0,

            leading: Container(
              child: IconButton(onPressed: (){
                // Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  CompanyPage() ),
                );

              }, icon: Icon(Icons.arrow_back, color: Colors.white )),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: InkWell(onTap: () async{

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AYC_Bot(sede: widget.sede,)));

                }, child: Icon(Icons.refresh) ),
              )
            ],
          ),


          body:Column(
            children: [
              Expanded(
                child: FutureBuilder(
                    future: RequestCantidadIncidente(),
                    builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>

                    snapshot.hasData ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) {

                          String sede = '${widget.sede}';
                          String origen = "${snapshot.data![index]['origen_ayc']}";

                          if(origen == 'C'){
                            origen = 'CONDICION';
                          }else if (origen == 'A'){
                            origen = 'ACTO';
                          }

                          String? area_base = snapshot.data![index]['nombre_area_base'];
                          if(area_base == 'null' || area_base == null){
                            area_base = 'No Especifíca';
                          }

                          return Container(
                            width: MediaQuery.of(context).size.width*1,
                            // render list item
                            child: ListTile(
                              onTap: (){

                         int idAyC = snapshot.data![index]['ayc_registro_id'];

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AyCBotDetalle(
                                            idAyC: idAyC,
                                            fb_id : sede
                                        ),),);
                                },

                              title: Container(

                                child: Row(
                                    children: [
                                      Expanded(
                                        child:
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0),
                                            ),
                                          ),
                                          elevation: 5,
                                          child:
                                          Padding(
                                            padding: EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
                                            child: IntrinsicHeight(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width*1,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 14,
                                                        height: double.infinity,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: colorEstado,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(10),
                                                                bottomLeft: Radius.circular(10)
                                                            ), ),
                                                        )
                                                    ),

                                                    SizedBox(width: 10,),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                 //   Icon(Icons.insert_drive_file_outlined, size: 16,),
                                                               //     SizedBox(width: 5,),
                                                                    Text("${snapshot.data![index]['codigo']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                                                  ],
                                                                ),
                                                                Text("${snapshot.data![index]['fecha'].substring(0,10)} -" " ${snapshot.data![index]['hora'].substring(0,5)}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: S2BColors.primaryColor),),
                                                              ],
                                                            ),
                                                            Divider(height: 14,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("${area_base}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                                              ],
                                                            ),
                                                            SizedBox(height: 4,),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Text("${snapshot.data![index]['descripcion']}", maxLines: 2, style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.6),))
                                                              ],
                                                            ),
                                                            Divider(height: 14,),


                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(Icons.apartment_rounded, size: 18,),
                                                                    SizedBox(width: 6,),

                                                                    Text("${snapshot.data![index]['nombre_sede']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF505154)),),
                                                                  ],
                                                                ),


                                                                Container(
                                                                    width: 95,
                                                                    height: 25,
                                                                    child: ElevatedButton(onPressed: (){},
                                                                        style: ElevatedButton.styleFrom(
                                                                            shape: StadiumBorder(),
                                                                            backgroundColor: S2BColors.orange

                                                                        ),
                                                                        child: FittedBox(child: Text("${origen}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11) )  ))),
                                                              ],
                                                            )
                                                            //Suma de registros
                                                            //Lista de nro de total de factura y monto
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          );
                        }
                    )

                        : const Center(
                      // render the loading indicator
                      child: CircularProgressIndicator(),
                    )),
              ),
              /*
              FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 6000), (){}),
                // delay for 2 seconds

                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Cargando ..."),
                    );
                  }
                  else {
                    // return your UI widgets with the data
                    return Container(
                      height: 50,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.1),
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: [
                                Image.asset("assets/icons/icon-estado-rojo.png", width: 25,),
                                SizedBox(width: 10,),
                                Text("${sumaRojo}", style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                              ],
                            ),

                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                            Row(
                              children: [
                                Image.asset("assets/icons/icon-estado-naranja.png", width: 25,),
                                SizedBox(width: 10,),
                                Text("${sumaNaranja}", style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness:  0.5,
                            ),
                            Row(
                              children: [

                                Text("Total:   "),
                                Text("${sumaRojo!+sumaNaranja!}", style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              */
            ],
          )
      ),
    );
  }

  //Request JSON directo
  Future <List< dynamic>> RequestCantidadIncidente() async {
    final user = await authController.getUserFromStorage();

    var url = '${user!.urlApp}/ws/null/pr_ws_ayc_registros_bot?id_sede=${widget.sede}';
    var mapIncGen = Map<String, dynamic>();
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "userLogin": "${user.userLogin}@${user.arroba}",
          "userPassword": "${user.password}",
          "systemRoot": "${user.enterprise}"
        },
        body: jsonEncode(mapIncGen)
    );

    print("${response.statusCode}");
    // print("${response.body}");
    // OBJECT JSON
    // var data =[];
    // data = json.decode(response.body)['data'] ;
    var data = jsonDecode(response.body)['data'];
    List  results = [];
    //   results = data.map((e) => EmpleadoIncGen_model.fromJson(e)).toList();
    print("data ----> ${data}]");
    return data;
  }
}



