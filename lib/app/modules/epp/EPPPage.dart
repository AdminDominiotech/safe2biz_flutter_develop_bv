import 'package:flutter/material.dart';

class EPPPage extends StatelessWidget {
  const EPPPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entrega EPP ", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),),
      body: Column(
        children: [
          Container(
            child: Text("Pagina epp", style: TextStyle(color: Colors.black),),
          ),
        ],
      )
    );
  }
}
