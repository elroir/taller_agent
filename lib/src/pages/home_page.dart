import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tallercall/constants.dart';
import 'package:tallercall/src/models/appointment_model.dart';
import 'package:tallercall/src/providers/database_provider.dart';
import 'package:tallercall/src/providers/info.dart';
import 'package:tallercall/src/services/tts_service.dart';
import 'package:tallercall/src/services/user_prefs.dart';

import 'package:tallercall/src/widgets/cutom_buttom_widget.dart';
import 'package:tallercall/src/widgets/mic_button_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _firestore = Database();

  final _prefs = UserPrefs();

  AppointmentModel _appointmentModel = new AppointmentModel();

  DateTime date = DateTime.now();
  
  @override
  Widget build(BuildContext context) {

    final info = Provider.of<Info>(context);

    final size = MediaQuery.of(context).size;

    final TextStyle description = TextStyle(fontSize: 13.0,fontWeight: FontWeight.w300);

    final TextStyle title       = TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold);
    
   _prefs.lastPage = 'home';


   register(info);

   vehicleState(info);

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity,height: size.height*0.15,),
          CustomButtom(
            alto: size.height*0.2,
            ancho: size.width*0.7,
            colorFondo: Colors.white,
            imagen: Image.asset('assets/images/calendar.png',fit: BoxFit.cover,),
            texto: Text('Reservar servicio',style: title,),
            descripcion: Text('Puede hacer la reserva del servicio que desee, sin necesidad de registrarse',style: description,),
            onPressed: () {
              Navigator.pushNamed(context, 'appointment');
            },
          ),
          SizedBox(height: size.height*0.05,),
          CustomButtom(
            alto: size.height*0.2,
            ancho: size.width*0.7,
            colorFondo: Colors.white,
            imagen: Image.asset('assets/images/login.png',fit: BoxFit.scaleDown,),
            texto: Text('Iniciar sesion',style: title,),
            descripcion: Text('inicie sesion o registrese para poder contar con todas las funcionalidades',style: description,),
            onPressed: () async {
              Navigator.pushNamed(context, 'login');
            },
          ),
          SizedBox(height: size.height*0.05,),
          SizedBox(height: size.height*0.05,),
        ],
      ),
      floatingActionButton: MicWidget(info: info,),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }


  void register(Info info){

    if (kAppointmentIntents.contains(info.intent)){

      if (info.intent=='Fijar dia y hora'||info.intent=='Fijar dia')
          date = DateTime.parse(info.queryResult.parameters['dia']);
      if (date.weekday!= 7) {

        String response = info.queryResult.fulfillmentText;

        if (info.intent=='Fijar dia y hora'||info.intent=='Fijar hora'){
          info.intent='';
          response = response.substring(0,response.length-6);
          String day = date.toString();
          day = day.substring(0,10);
          String hour = info.queryResult.parameters['hora'];
          hour = hour.substring(11,hour.length-9);
          _appointmentModel.estado = 'aprobado';
          _appointmentModel.fecha = day;
          _appointmentModel.hora = hour;
          _prefs.hour = hour;
          _prefs.date = info.queryResult.parameters['dia'];
          _firestore.mainCollectionAddData(
              'Citas', _appointmentModel.toJson());
        }
        speak(response);
      }
      else
        speak('Lo siento, no atendemos los domingos');
    }

  }

  void vehicleState(Info info) async {
    if (_prefs.lastAppointment!=''){
      DocumentSnapshot appointment = await  _firestore.getAppointment('Citas', _prefs.lastAppointment);
      if (info.intent=='Estado'){
        String state = appointment['estado'];
        info.intent='';
        speak(info.queryResult.fulfillmentText + state);
      }
    }else if (info.intent=='Estado')
      speak('No tiene ninguna cita actualmente, esto quiere decir que su vehiculo esta listo o que no ha programado ninguna cita');

  }

}
