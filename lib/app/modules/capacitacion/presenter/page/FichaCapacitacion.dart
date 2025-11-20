import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:share_plus/share_plus.dart';

class FichaCapacitacion extends StatefulWidget {
  final String? idCurso, formattedDate, idSede;
  final String path;

  FichaCapacitacion({Key? key, required this.path, this.idCurso, this.formattedDate, this.idSede}) : super(key: key);

  _FichaCapacitacion createState() => _FichaCapacitacion();
}

class _FichaCapacitacion extends State<FichaCapacitacion> with WidgetsBindingObserver {

  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";
  String? path;


  @override
  void initState() {
    super.initState();
    asyncMethod();

  }

  void asyncMethod() async {
    final output = await getTemporaryDirectory();
     path = '/data/user/0/com.dominiotech.s2bsafe2biz/cache/Asistencia-Cap-${widget.idCurso}.pdf';

  }
  final auth = GetIt.I<AuthController>();



//File? file;

  @override
  Widget build(BuildContext context) {

    /*
    Future.delayed(const Duration(milliseconds: 1000), () {

      refresh();

    });
    */

    void _onShare() async{
      var dir = await getApplicationDocumentsDirectory();
      final output = await getTemporaryDirectory();
      // File file = File("${dir.path}/${widget.filename}");

   //   Share.shareFiles(['data/user/0/com.dominiotech.safe2bizapp/cache/Asistencia-Cap-${widget.idCurso}.pdf'], text: 'Capacitacion.pdf', mimeTypes: ['application/pdf'], );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A3987),
        title: Text("Ficha de Asistencia", style: TextStyle(fontSize: 16, color: Colors.white,), ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _onShare();
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF525659),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.height*0.75,
              child: Align(
                alignment: Alignment.center,
                child: Container(

                  child: PDFView(



                    filePath: '/data/user/0/com.dominiotech.s2bsafe2biz/cache/Asistencia-Cap-${widget.idCurso}.pdf',
                   // filePath: widget.path,
                    enableSwipe: true,
                    fitEachPage: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    pageSnap: true,
                    nightMode: false,
                    defaultPage: currentPage!,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation:
                    false, // if set to true the link is handled in flutter
                    onRender: (_pages) {
                      setState(() {
                        pages = _pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    onLinkHandler: (String? uri) {
                      print('goto uri: $uri');
                    },
                    onPageChanged: (int? page, int? total) {
                      print('page change: $page/$total');
                      setState(() {
                        currentPage = page;
                      });
                    },
                  ),
                ),
              ),
            ),
            errorMessage.isEmpty
                ? !isReady
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Container()
                : Center(
              child: Text(errorMessage),
            )
          ],
        ),
      ),

      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return  Container(
              decoration: BoxDecoration(  color: Color(0XFF3B3B3B),   borderRadius: BorderRadius.circular(5.0) ),
              width: MediaQuery.of(context).size.width*0.5,
              height: 45,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[

                    Container(
                        width: MediaQuery.of(context).size.width*0.10,
                        child: FloatingActionButton.extended(
                            elevation: 0,
                            backgroundColor:Color(0XFF3B3B3B),
                            onPressed: () async{
                              await snapshot.data!.setPage(currentPage!-1);
                            },
                            label: Icon(Icons.remove ) )),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
                      child: Row(
                        children: [
                          Text("Página ", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                          SizedBox(width: 5,),
                          Text("${currentPage!+1}  /  $pages ", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),

                    Container(

                        width: MediaQuery.of(context).size.width*0.10,
                        child: FloatingActionButton.extended(
                            elevation: 0,
                            backgroundColor:Color(0XFF3B3B3B),
                            onPressed: () async{
                              await snapshot.data!.setPage(currentPage!+1);
                            },
                            label: Icon(Icons.add)  )),
                  ]
              ),
            );
          }

          return Container();
        },
      ),

    );
  }
}
