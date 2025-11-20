import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



String horaEntrega = "";
String fechaEntrega = "";


class fechaHora extends StatefulWidget {
  const fechaHora({Key? key}) : super(key: key);

  @override
  State<fechaHora> createState() => _fechaHoraState();

}

class _fechaHoraState extends State<fechaHora> {

  String fechaInit = DateFormat("yyyy/MM/dd").format(DateTime.now());

  //Elegir fecha
  TextEditingController dateInput = TextEditingController();
  //Elegir hora
  TextEditingController timeinput = TextEditingController();
  @override
  void initState() {
    final value = TimeOfDay.now().toString();
    final newValue = value.replaceAll("TimeOfDay(", "").replaceAll("-", ")");
    final finalHour = newValue.substring(0, newValue.length - 1);
    timeinput.text = finalHour; //Valor inicial = dia actual
    dateInput.text = fechaInit; //Valor inicial = hora actual{{

    horaEntrega = finalHour;
    fechaEntrega = fechaInit;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.44,
          height: 53,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, // Set border color
                width: 1.5),   // Set border width
            borderRadius: BorderRadius.all(
                Radius.circular(4.0)), // Set rounded corner radius

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                      Container(
                        padding: EdgeInsets.zero,
                        width: MediaQuery.of(context).size.width*0.30,
                   //     width: MediaQuery.of(context).size.width*0.45,
                        height: 50,

                        child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: TextField(


                              controller: dateInput,
                              //editing controller of this TextField
                              decoration: InputDecoration(

                                  border: InputBorder.none,
                                  label: Column(
                                    children: [

                                      Text("Fecha", style: TextStyle(color: Color(0xffC4C4C4), fontSize: 15, fontWeight: FontWeight.w400),),
                                      SizedBox(height: 8,),
                                    ],
                                  ),  //label text of field
                                //  icon: Icon(Icons.calendar_today, color: Color(0xff00297B),), //icon of text field

                              ),
                                 //  readOnly: true,
                                //   set it true, so that user will not able to edit text

                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(



                                    context: context,
                                    initialDate: DateTime.now(),
                                    locale: const Locale("es", "ES"),

                                    firstDate: DateTime(2000),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2030),

                                     builder: (context, child) {
                                       return Theme(
                                         data: ThemeData.dark().copyWith(
                                           primaryColor: Color(0xff0A3987),
                                             colorScheme: const ColorScheme
                                                 .light(
                                                 onPrimary: Colors.white,
                                                 // selected text color
                                                 onSurface: Color(0xff0A3987),
                                                 // default text color
                                                 primary: Color(0xff0A3987), // circle color
                                             ),
                                             dialogBackgroundColor: Colors.white,

                                             textButtonTheme: TextButtonThemeData(
                                                 style: TextButton.styleFrom(
                                                     textStyle: const TextStyle(
                                                         color:  Color(0xffEF8E3B),
                                                         fontWeight: FontWeight
                                                             .normal,
                                                         fontSize: 12,
                                                         fontFamily: 'Quicksand'),
                                                     backgroundColor: Colors.white,
                                                     // color of button's letters
                                       //              backgroundColor:  Color(0xff0A3987),
                                                     // Background color
                                                     shape: RoundedRectangleBorder(
                                                         side: const BorderSide(

                                                           color: Colors.grey,
                                                             width: 0.5,
                                                             style: BorderStyle
                                                                 .solid),
                                                         borderRadius: BorderRadius
                                                             .circular(50))))),
                                         child: child!,
                                       );
                                     });



                                if (pickedDate != null) {
                                  print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
                                  String anhoFormatted = DateFormat('yyyy').format(pickedDate);
                                  print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    dateInput.text = formattedDate.substring(0,10);
                                    fechaEntrega = formattedDate.substring(0,10);

                                  });
                                } else {}

                              },
                              style: TextStyle(fontSize:13, fontWeight: FontWeight.w400, color: Colors.black87),  ),

                        ),

                        //Icon

                      ),


                    ],

              ),

              Icon(Icons.calendar_today, color: Color(0xff00297B), size: 28, ),

            ],
          ),
        ),




        //=======>HORA

        Container(
          width: MediaQuery.of(context).size.width*0.44,
          height: 53,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, // Set border color
                width: 1.5),   // Set border width
            borderRadius: BorderRadius.all(
                Radius.circular(4.0)), // Set rounded corner radius

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width*0.34,
                    height: 50,

                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextField(

                        controller: timeinput,
                        //editing controller of this TextField
                        decoration: InputDecoration(

                          border: InputBorder.none,
                          label: Column(
                            children: [

                              Text("Hora", style: TextStyle(color: Color(0xffC4C4C4), fontSize: 15, fontWeight: FontWeight.w400),),
                              SizedBox(height: 10,),
                            ],
                          ),  //label text of field
                          //  icon: Icon(Icons.calendar_today, color: Color(0xff00297B),), //icon of text field

                        ),
                        //  readOnly: true,
                        //   set it true, so that user will not able to edit text

                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,

                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {


                              MediaQuery(
                                data:
                                MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child ?? Container(),
                              );


                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    // change the border color
                                    primary:   Color(0xffEF8E3B),
                                    // change the text color
                                    onSurface:Color(0xff0A3987),
                                  ),
                                  // button colors
                                  buttonTheme: ButtonThemeData(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.green,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );


                              /*
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child ?? Container(),
                              );
                               */
                            },
                            initialEntryMode: TimePickerEntryMode.dial,

                          );


                          if(pickedTime != null ){
                            print(pickedTime.format(context));   //output 10:51 PM

                            /* DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                                              //converting to DateTime so that we can further format on different pattern.
                                              print(parsedTime); //output 1970-01-01 22:53:00.000
                                              String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                                              print(formattedTime); //output 14:59:00
                                              //DateFormat() is from intl package, you can format the time on any pattern you need.
*/
                            setState(() {
                              timeinput.text = pickedTime.format(context); //set the value of text field.
                              horaEntrega = pickedTime.format(context);
                            });
                          }else{}

                        },
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w400, color: Colors.black87),  ),

                    ),

                    //Icon

                  ),


                ],

              ),

              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: Color(0xff00297B), size: 28,),
                  SizedBox(width: 5,)
                ],
              ),

            ],
          ),
        ),

      ],
    );
  }
}


