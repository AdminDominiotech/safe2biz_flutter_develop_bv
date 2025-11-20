import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

String? fechaEntrega;

class fechaFiltro extends StatefulWidget {
  const fechaFiltro({Key? key}) : super(key: key);

  @override
  State<fechaFiltro> createState() => _fechaFiltroState();

}

class _fechaFiltroState extends State<fechaFiltro> {


  //Elegir fecha
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {

    dateInput.text = '' ;
    //Valor inicial = hora actual
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Container(
          width: 155,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, // Set border color
                width: 1.5),   // Set border width
            borderRadius: BorderRadius.all(
                Radius.circular(4.0)), // Set rounded corner radius

          ),
          child:TextField(
              controller: dateInput,
              //editing controller of this TextField
              decoration: InputDecoration(

                border: InputBorder.none,
                label: Text("Fecha Vigencia", style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.3),),  //label text of field
                icon: Icon(Icons.calendar_today, color: Color(0xff00297B),), //icon of text field

              ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    locale: const Locale("es", "ES"),
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  print(formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    dateInput.text = formattedDate;
                    fechaEntrega = formattedDate.toString();

                    //Navigation.push();
                  });
                } else {}
              },
            ),

        ),

        SizedBox(width: 50,),

      ],
    );
  }
}
