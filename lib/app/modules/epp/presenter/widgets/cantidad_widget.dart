import 'package:flutter/material.dart';

int cantidad = 1;


class cantidadProd extends StatefulWidget {
  @override
  __IntegerExampleState createState() => __IntegerExampleState();


}

class __IntegerExampleState extends State<cantidadProd> {


  @override
  Widget build(BuildContext context) {
    return          Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(

                color: Color(0xffFAFAFA),

              ),



                child: IconButton(
                  icon: Icon(Icons.remove, color: Color(0xff0A3987)),
                  onPressed: () => setState(() {
                    final newValue = cantidad - 1;
                    cantidad = newValue.clamp(1, 30);
                  }),
                ),

            ),
            Container(

                child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(


                      border: Border.all(
                          color: Colors.grey,
                          width: 1.0
                      ),

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$cantidad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ))),
            Container(

              decoration: BoxDecoration(
                color: Color(0xffFAFAFA),


              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Color(0xff0A3987)),
                onPressed: () => setState(() {
                  final newValue = cantidad + 1;
                  cantidad = newValue.clamp(1, 30);
                }),
              ),
            ),
          ],
        ),
      ],
    );

  }
}