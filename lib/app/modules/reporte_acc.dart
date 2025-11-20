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

class ReporteAcc extends StatefulWidget {
  final String? path, filename, formattedDate, idSede;

  ReporteAcc({Key? key, this.path, this.filename, this.formattedDate, this.idSede}) : super(key: key);

  _ReporteAcc createState() => _ReporteAcc();
}

class _ReporteAcc extends State<ReporteAcc> with WidgetsBindingObserver {



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


  @override
  void initState() {
    super.initState();

    print("path ---- ${widget.path}");
    print("filename ---- ${widget.filename}");

    /*
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
    */

  }

  final auth = GetIt.I<AuthController>();
//File? file;


  void refresh() async{
    setState(() {

    });
}

  @override
  Widget build(BuildContext context) {

    /*
    Future.delayed(const Duration(milliseconds: 1000), () {
      refresh();
    });
    */

    void _onShare() async{
      var dir = await getApplicationDocumentsDirectory();

      // File file = File("${dir.path}/${widget.filename}");

      print("path ---- ${widget.path}");
      print("filename ---- ${widget.filename}");
      print("dir.path ---- ${dir.path}");
      print("path + filename --'${dir.path}/${widget.filename}");
      print("formatted date --- ${widget.formattedDate}");
   //   Share.shareFiles(['${dir.path}/ReporteAcc-${widget.formattedDate}-${widget.idSede}-${auth.getID}.pdf'], text: 'InvestigacionAcc.pdf', mimeTypes: ['application/pdf'], );
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A3987),
        title: Text("Reporte de Planes de Acción", style: TextStyle(fontSize: 16),),
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

                    filePath: widget.path,
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
