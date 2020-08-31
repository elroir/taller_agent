import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tallercall/constants.dart';
import 'package:tallercall/src/providers/database_provider.dart';
import 'package:tallercall/src/services/auth.dart';
import 'package:tallercall/src/services/user_prefs.dart';
import 'package:tallercall/src/utils/utils.dart';
import 'package:tallercall/src/widgets/custom_square.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firestore = Database();

  final _prefs = UserPrefs();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    _prefs.lastPage='profile';

    print(_prefs.lastAppointment);

    return Scaffold(
      body: Stack(
        children : [
          CustomSquare(height:size.height*0.4 ,),
          _body( context)
        ]
      ),
    );
  }

  _body(BuildContext context){

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: size.height*0.04,),),
          _userData(context),
          SizedBox(height: size.height*0.03,width: size.width,),
          Text('Vehiculos',style: kTextStyleTitleWhite,),
          SizedBox(height: size.height*0.03,),
          _vehicleData(context),
          SizedBox(height: size.height*0.05,),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
            ),
            color: Colors.red,
            child: Text('Reservar servicio',style: TextStyle(color: Colors.white),),
            onPressed: (){
              Navigator.pushNamed(context, 'logged_appointment');
            },
          ),
          SizedBox(height: kSeparation,),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            color: Colors.red,
            child: Text('Estado actual',style: TextStyle(color: Colors.white),),
            onPressed: () async {
              DocumentSnapshot appointment = await  _firestore.getAppointment('Citas', _prefs.lastAppointment);
              String content = appointment['estado'];
              createSimpleDialog(context, 'Su estado actual es', content);
            },
          ),
          SizedBox(height: kSeparation,),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
            ),
            color: Colors.red,
            child: Text('Cerrar sesion',style: TextStyle(color: Colors.white),),
            onPressed: (){
              _auth.signOut();
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),
          SizedBox(height: size.height*0.2,)
        ],

      ),
    );
  }

  StreamBuilder _userData(BuildContext context){

    final size = MediaQuery.of(context).size;

    return StreamBuilder<DocumentSnapshot>(
        stream:_firestore.getUserStream("Usuarios",_prefs.uid),
        builder: (BuildContext context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            return Container(
              width: size.width,
              child: Column (
                children: [
                  Text(data['nombre'] + " " + data['apellido'],style: kTextStyleTitleWhite,),
                  SizedBox(height: 5.0,),
                  Text(_prefs.email,style: kTextStyleWhite,),
                  SizedBox(height: 5.0,),
                  Text(data['telefono'].toString(),style: kTextStyleWhite,),
                  SizedBox(height: 5.0,),
                ],
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }

        }
    );

  }

  Widget _vehicleData(BuildContext context){

    final size = MediaQuery.of(context).size;

    return  Container(
      width: size.width*0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 0.5)
      ),
      child: StreamBuilder<DocumentSnapshot>(
          stream:_firestore.getUserStream("Usuarios",_prefs.uid),
          builder: (BuildContext context, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData) {
              List vehicles = (data['vehiculos']!=null) ? data['vehiculos'] : [] ;
              return Column (
                  children: [
                    ListTile(
                      leading: Icon(Icons.directions_car,color: Colors.black,),
                      title: Text(vehicles.last['marca'] + " " + vehicles.last['modelo']),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today,color: Colors.black,),
                      title: Text(vehicles.last['anho'].toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.check,color: Colors.black,),
                      title:(vehicles.last['matricula']!=null)
                          ? Text(vehicles.last['matricula'])
                          : Text('Un administrador pondra su placa')
                      ),
                    ListTile(
                      leading: Text('VIN',style: TextStyle(fontSize: 20.0),),
                      title: (vehicles.last['vin']!=null)
                          ? Text(vehicles.last['vin'])
                          : Text('Un administrador pondra su VIN'),
                    ),
                    SizedBox(height: size.height*0.02,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      color: Colors.red,
                      child: Text('Historial',style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        Navigator.pushNamed(context, 'historic');
                      },
                    ),
                    SizedBox(height: size.height*0.02,),
                  ],
                );

            }else{
              return Center(child: CircularProgressIndicator(),);
            }

          }
      ),
    );
  }


}
