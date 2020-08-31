import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:tallercall/constants.dart';
import 'package:tallercall/src/models/appointment_model.dart';
import 'package:tallercall/src/providers/database_provider.dart';
import 'package:tallercall/src/providers/info.dart';
import 'package:tallercall/src/services/user_prefs.dart';
import 'package:tallercall/src/utils/utils.dart';
import 'package:tallercall/src/widgets/custom_square.dart';

class AppointmentPage extends StatefulWidget {

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  String _date = '';
  String _time = '';
  final _firestore = Database();
  AppointmentModel _appointmentModel = new AppointmentModel();
  final _prefs = UserPrefs();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final info = Provider.of<Info>(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,elevation: 0.0,),
      body: Stack(
        children: [
          CustomSquare(),
          _body(context,info)
        ],
      ),

    );

  }

  Widget  _body(BuildContext context,Info info){

    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: size.width,),
        Row(
          children: [
            Icon(Icons.calendar_today,size: 120.0,color: Colors.white,),
            _prefs.lastAppointment!='' ? _currentAppointment(context,info) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha: ',style: kTextStyleTitleWhite,),
                (_date!='') ? Text(_date,style: kTextStyleWhite,) : Container(width: 50.0,child: Divider(color: Colors.white,thickness: 3.0,)),
                Text('Hora: ',style: kTextStyleTitleWhite,),
                (_time!='') ? Text(_time,style: kTextStyleWhite,) : Container(width: 50.0,child: Divider(color: Colors.white,thickness: 3.0,)),
              ],
            )
          ],
        ),
        SizedBox(height: size.height*0.15,),
        RaisedButton(
          color: Colors.red,
          child: Text('Elegir horario',style: TextStyle(color: Colors.white),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime.now().add(new Duration(days: 15)),
                onConfirm: (date) {
                if (date.weekday!=7){
                  setState(() {
                    _date = date.toString();
                    _time = _date.substring(11,16);
                    _date = _date.substring(0,10);

                  });
                }else{
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Por favor, seleccione otro dia') ,
                          content: Text('Lo sentimos, no atendemos los Domingos'),
                          actions: <Widget>[
                            Row(
                              children: [
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      }
                  );
                }

                },
                currentTime: DateTime.now(), locale: LocaleType.es);
          },
        ),
        RaisedButton(
          color: Colors.red,
          child: Text('Confirmar',style: TextStyle(color: Colors.white),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            if(_date!='') {
              _appointmentModel.estado = 'aprobado';
              _appointmentModel.fecha = _date;
              _appointmentModel.hora = _time;
              _prefs.hour = _time;
              _prefs.date = _date;
              _firestore.mainCollectionAddData(
                  'Citas', _appointmentModel.toJson());
              setState(() {

              });
            }else
              createSimpleDialog(context, 'No ha elegido una fecha', 'Por favor, primero elija una fecha y hora');
          },
        ),
      ],

    );

  }

  StreamBuilder _currentAppointment(BuildContext context,Info info){

    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.getUserStream('Citas', _prefs.lastAppointment),
        builder: (context, snapshot) {

          final data = snapshot.data;

          if(data['estado']=="finalizado"){
            _prefs.lastAppointment='';

          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fecha: ',style: kTextStyleTitleWhite,),
              Text(data['fecha'],style: kTextStyleWhite,),
              Text('Hora: ',style: kTextStyleTitleWhite,),
              Text(data['hora'],style: kTextStyleWhite,),
            ],
          );
        }
    );

  }


  void createDialog(BuildContext context,String title,String content){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title) ,
            content: Text(content),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {

                      Navigator.of(context).pushReplacementNamed('home');
                    },
                  ),
                ],
              )
            ],
          );
        }
    );
  }

}
