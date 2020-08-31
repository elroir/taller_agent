import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tallercall/constants.dart';
import 'package:tallercall/src/providers/database_provider.dart';
import 'package:tallercall/src/services/user_prefs.dart';
import 'package:tallercall/src/widgets/custom_square.dart';

class HistoricPage extends StatelessWidget {

  final _prefs = UserPrefs();

  final _firestore = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,elevation: 0.0,),
      body: _body(context),
      backgroundColor: Colors.red,

    );

  }


  _body(BuildContext context){

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text('Historial de servicios',style: kTextStyleTitleWhite,),
        SizedBox(height: size.height*0.04,width: size.width,),
        Container(
          height: size.height*0.6 ,
          child: _buildHistoric(context)
        )

      ],
    );
  }

  StreamBuilder _buildHistoric(BuildContext context){
   
    return StreamBuilder<QuerySnapshot>(
        stream:_firestore.getCollectionStream("Citas",_prefs.uid,"usuario"),
        builder: (BuildContext context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            return ListView(
              children: _historicItems(context, data.documents),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }

        }
    );

  }

  List<Widget> _historicItems(BuildContext context,List<DocumentSnapshot> data){

    final List<Widget> historics = [];

    data.forEach((item) {
      final widgetTemp = Card(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
          title: Text("fecha de ingreso: " + item['fecha'],),
          subtitle: Text(item['descripcion'],),

        ),

      );
      historics.add(widgetTemp);
      historics.add(SizedBox(height: kSeparation,));
    });

    return historics;

  }

}
