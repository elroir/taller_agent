import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tallercall/constants.dart';
import 'package:tallercall/src/models/appointment_model.dart';
import 'package:tallercall/src/providers/database_provider.dart';
import 'package:tallercall/src/providers/info.dart';
import 'package:tallercall/src/services/tts_service.dart';
import 'package:tallercall/src/services/user_prefs.dart';
import 'package:tallercall/src/utils/utils.dart';
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
  
  @override
  Widget build(BuildContext context) {

    final info = Provider.of<Info>(context);

    final size = MediaQuery.of(context).size;

    final TextStyle description = TextStyle(fontSize: 13.0,fontWeight: FontWeight.w300);

    final TextStyle title       = TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold);
    
   _prefs.lastPage = 'home';

   register(info);

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
            onPressed: () {
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

      DateTime date = DateTime.parse(info.queryResult.parameters['dia']);
      if (date.weekday!= 7) {

        String response = info.queryResult.fulfillmentText;

        print(response);



        final format = new DateFormat.MMMMd('es_ES');
        String converted = format.format(date);

        print(converted);
        speak(response);
      }
      else
        speak('Lo siento, no atendemos los domingos');
    }

  }

}
