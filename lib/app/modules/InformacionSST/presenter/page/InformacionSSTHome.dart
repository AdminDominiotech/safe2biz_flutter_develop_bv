import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/MiInformacion.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/MisMensajes.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/MisPendientes.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/SearchPage.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';

class InformacionSST_Home extends StatefulWidget {
  final String? sede, fb_emp_id;
  const InformacionSST_Home({Key? key, this.sede, this.fb_emp_id}) : super(key: key);

  @override
  State<InformacionSST_Home> createState() => _InformacionSST_HomeState();
}

final apiEmp = ApiEntregaEpp();

class _InformacionSST_HomeState extends State<InformacionSST_Home> {
  void initState(){
    super.initState();
  }

  Future<void> _closeIme() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (nav.canPop()) {
          nav.pop();
        } else {
          nav.pushReplacementNamed('/home');
        }
      },

      child: Scaffold(
        appBar: AppBarBack(
          'Información SST',
          onPressed: () async {
            // cerrar IME
            FocusManager.instance.primaryFocus?.unfocus();
            await SystemChannels.textInput.invokeMethod('TextInput.hide');
            await Future<void>.delayed(const Duration(milliseconds: 120));
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              await nav.maybePop();
            } else {
              nav.pushReplacementNamed('/home');
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.94,
                      height: 90,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MiInformacion(sede: widget.sede, fb_empleado_id: widget.fb_emp_id, shouldReset: true,)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: S2BColors.orange,
                                width: 2//<-- SEE HERE
                            ),
                          ),

                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),

                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color:  S2BColors.orange,
                                          ),
                                          padding:  EdgeInsets.all(8.0),
                                          child: Image.asset('assets/icons/person_info.png',  width: 40, color: Colors.white,)
                                      ),

                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 14),
                                        child: Text("Mi Información", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Icon(Icons.arrow_forward_ios_rounded),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                      width: MediaQuery.of(context).size.width*0.94,
                      height: 90,
                      child: InkWell(
                        onTap: (){
                  //        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MisPendientes(sede: sede, fb_empleado_id: fb_emp_id,)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: S2BColors.orange,
                                width: 2//<-- SEE HERE
                            ),
                          ),
                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),

                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color:  S2BColors.orange,
                                          ),
                                          padding:  EdgeInsets.all(8.0),
                                          child: Image.asset('assets/icons/icon-pendiente.png',  width: 40, color: Colors.white,)
                                      ),

                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 14),
                                        child: Text("Mis Pendientes", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    child: Icon(Icons.arrow_forward_ios_rounded),
                                  )


                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                      width: MediaQuery.of(context).size.width*0.94,
                      height: 90,
                      child: InkWell(
                        onTap: (){
                      //    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage() ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: S2BColors.orange,
                                width: 2//<-- SEE HERE
                            ),
                          ),
                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),

                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color:  S2BColors.orange,
                                          ),
                                          padding:  EdgeInsets.all(8.0),
                                          child: Image.asset('assets/icons/icon-mensajes.png',  width: 40, color: Colors.white,)
                                      ),

                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 14),
                                        child: Text("Mis Mensajes", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500,  ),),
                                      ),
                                    ],
                                  ),

                                  Container(
                                    child: Icon(Icons.arrow_forward_ios_rounded),
                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
