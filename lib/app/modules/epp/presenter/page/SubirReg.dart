import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:flutter/material.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/estadistica_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';

class SubirReg extends StatefulWidget {
  final String sede;

  const SubirReg({Key? key, required this.sede}) : super(key: key);

  @override
  State<SubirReg> createState() => _SubirRegState();
}

class _SubirRegState extends State<SubirReg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff0A3987),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Subido Exitosamente",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 190,
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BottomNavLayout(
                              lazyLoadPages: true,
                              pages: [
                                (_) => ListaPersonal(
                                      sede: "${widget.sede}",
                                    ),
                                (_) => EstadisticaEntrega(),
                              ],
                              bottomNavigationBar: (currentIndex, onTap) =>
                                  BottomNavigationBar(
                                currentIndex: currentIndex,
                                onTap: (index) => onTap(index),
                                selectedItemColor: Colors.orange,
                                items: [
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.list_alt),
                                      label: 'Lista'),
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.bar_chart_outlined),
                                      label: 'Estadisticas'),
                                ],
                              ),
                            )));
                  },
                  child: Text(
                    "Volver",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff0A3987),
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
