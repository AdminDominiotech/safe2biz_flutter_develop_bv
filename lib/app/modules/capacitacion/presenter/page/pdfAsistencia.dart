import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/capacitacion_detalle.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';



File? _imageFile;
SqlDb sqlDb = SqlDb();
bool isPhoto = false;


class AsistenciaPhoto extends StatefulWidget {

  const AsistenciaPhoto({Key? key, this.idCurso}) : super(key: key);
  @override
  _AsistenciaPhotoState createState() => _AsistenciaPhotoState();
  final String? idCurso;
}

class _AsistenciaPhotoState extends State<AsistenciaPhoto> {
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {

      _imageFile = File(pickedFile!.path);
      isPhoto = true;
    });
  }

  Future<void> _convertToPdf(File img) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(img.readAsBytesSync())),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Asistencia-Cap-${widget.idCurso}.pdf");
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at ${file.path}");
  }


  void initState(){
    super.initState();

   // _pickImage(ImageSource.camera);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack('Asistencia',),


      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom:0.0),
              color: Color(0xff09357E),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 12, top: 10),
                        child: Container(child: Text("Guardar Lista de Asistencia", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Visibility(
                    visible: !isPhoto,
                    child: Container(
                      child: Column(
                        children: [

                          SizedBox(height: 60,),
                          DottedBorder(
                            padding: EdgeInsets.all(8.0),
                            color: Color(0xff00297B),
                            radius: Radius.circular(10.0),
                            strokeWidth: 2,
                            dashPattern: [10, 5],
                            customPath: (size) {
                              return Path()
                                ..moveTo(10, 0)
                                ..lineTo(size.width - 10, 0)
                                ..arcToPoint(
                                    Offset(size.width, 10),
                                    radius: Radius.circular(10))
                                ..lineTo(size.width,
                                    size.height - 10)
                                ..arcToPoint(Offset(
                                    size.width - 10,
                                    size.height),
                                    radius: Radius.circular(10))
                                ..lineTo(10, size.height)
                                ..arcToPoint(
                                    Offset(0, size.height - 10),
                                    radius: Radius.circular(10))
                                ..lineTo(0, 10)
                                ..arcToPoint(Offset(10, 0),
                                    radius: Radius.circular(10));
                            },

                            child:
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(
                              onTap: (){

                                _pickImage(ImageSource.camera);
                              },
                              child: Column(

                                children: [
                                  Icon(Icons.camera_alt_rounded, size: 150, color: Color(0XFFB6B6B6),),
                                  Container (
                                    child: Text('Tomar captura', style: TextStyle(color: Color(0XFFB6B6B6), fontSize: 22)),
                                  ),
                                ],
                              ),
                          ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(height: 2,),
                Container(
                  child: Visibility(
                    visible: !isPhoto,
                    child: Container(
                      child: Column(
                        children: [

                          SizedBox(height: 60,),
                          DottedBorder(
                            padding: EdgeInsets.all(8.0),
                            color: Color(0xff00297B),
                            radius: Radius.circular(10.0),
                            strokeWidth: 2,
                            dashPattern: [10, 5],
                            customPath: (size) {
                              return Path()
                                ..moveTo(10, 0)
                                ..lineTo(size.width - 10, 0)
                                ..arcToPoint(
                                    Offset(size.width, 10),
                                    radius: Radius.circular(10))
                                ..lineTo(size.width,
                                    size.height - 10)
                                ..arcToPoint(Offset(
                                    size.width - 10,
                                    size.height),
                                    radius: Radius.circular(10))
                                ..lineTo(10, size.height)
                                ..arcToPoint(
                                    Offset(0, size.height - 10),
                                    radius: Radius.circular(10))
                                ..lineTo(0, 10)
                                ..arcToPoint(Offset(10, 0),
                                    radius: Radius.circular(10));
                            },

                            child:
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: (){

                                  _pickImage(ImageSource.gallery);
                                },
                                child: Column(

                                  children: [
                                    Icon(Icons.photo_library_sharp, size: 150, color: Color(0XFFB6B6B6),),
                                    Container (
                                      child: Text('Escoger Foto', style: TextStyle(color: Color(0XFFB6B6B6), fontSize: 22)),
                                    ),
                                  ],
                                ),
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
            
            SizedBox(height: 30,),
            Center(
              child: _imageFile == null
                  ? Text("")
                  : Container(
                width: MediaQuery.of(context).size.width*0.85,
                    child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox.fromSize(

                      child: Image.file(_imageFile!)),
                    ),
                  ),
            ),
            SizedBox(height: 20,),


            Visibility(
              visible: isPhoto,
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [


                       Column(
                        children: [



                          Container(
                              height: 50,
                              child: FloatingActionButton (


                                heroTag: "btn1",
                                elevation: 0,
                                backgroundColor: Color(0XFF6DAB30),
                                onPressed:  (){
                                  _imageFile != null ? _convertToPdf : null;
                                } ,
                                tooltip: 'Convert to PDF',
                                child: InkWell(
                                    onTap: () async{
                                      print("Se ha guardado");
                                      _convertToPdf(_imageFile!);

                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.leftSlide,
                                        headerAnimationLoop: false,
                                        dialogType:
                                        DialogType.success,
                                        showCloseIcon: true,
                                        title: 'Registrado',
                                        desc:
                                        'Se ha registrado la captura de foto en formato PDF',
                                        btnOkOnPress: () async {
                                          //_imageFile != null ? _convertToPdf : null;
                                        //  _convertToPdf(_imageFile!);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  CapacitacionDetalle(idCurso: widget.idCurso,)));
                                        },
                                        btnOkIcon: Icons.check_circle,
                                        onDismissCallback: (type) {
                                          debugPrint(
                                              'Dialog Dissmiss from callback $type');
                                        },
                                      ).show();


                                      int insertFlag =
                                          await sqlDb.insertData(
                                          "INSERT INTO 'capacitacion_photo' "
                                              "('id_curso', 'flag_photo') VALUES "
                                              "('${widget.idCurso}', '1' )");
                                      print("Se inserto el flag estado_bloc ============> ${insertFlag}");
                                      print("No hubo sincronizacion");
                                      print('image file ----$_imageFile');

                                    },
                                    child: Icon(Icons.check)),
                              ),
                            ),




                          SizedBox(height: 8,),
                          Text('Guardar', style: TextStyle(color: Color(0XFF505154)),)
                        ],
                      ),




                    Column(
                      children: [
                        Container(
                          height: 50,
                          child:     FloatingActionButton(
                            elevation: 0,
                            heroTag: "boton2",
                            backgroundColor: Color(0XFFDE3A3B),
                            onPressed: () => _pickImage(ImageSource.camera),
                            tooltip: 'Pick Image from Camera',
                            child: Icon(Icons.close),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Text('Eliminar', style: TextStyle(color: Color(0XFF505154)),)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

