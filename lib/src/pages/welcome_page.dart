import 'package:flutter/material.dart';
import 'package:tallercall/constants.dart';
import 'package:tallercall/src/providers/database_provider.dart';
import 'package:tallercall/src/services/user_prefs.dart';
import 'package:tallercall/src/widgets/custom_square.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  final formKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();

  TextEditingController _lastNameController = new TextEditingController();

  TextEditingController _vehicleController = new TextEditingController();

  TextEditingController _modelController = new TextEditingController();

  TextEditingController _phoneController = new TextEditingController();

  TextEditingController _ageController = new TextEditingController();

  TextEditingController _plateController = new TextEditingController();

  bool _isSubmiting = false;
  
  final _prefs = UserPrefs();
  
  final _firestore = Database();


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CustomSquare(height: size.height*0.4,),
          _body(context)
        ],
      ),
    );
  }

  Widget _body(BuildContext context){

    final size = MediaQuery.of(context).size;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(height: size.height*0.05,),
            ),
            Text('Bienvenido',style: kTextStyleTitleWhite,),
            SizedBox(width: size.width,height: 10.0,),
            Container(
              width: size.width*0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 0.5)
              ),
              child: Column(
                children: [
                  _nameField(),
                  SizedBox(height: kSeparation,),
                  _lastNameField(),
                  SizedBox(height: kSeparation,),
                  _phoneField(),
                  SizedBox(height: kSeparation*3,),
                  Text('Registra un vehiculo',style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: kSeparation,),
                  Container(
                    child: Row(
                      children: [
                        _makeField(context),
                        SizedBox(width: 10.0,),
                        _modelField(context),
                      ],
                    ),
                  ),
                  SizedBox(height: kSeparation,),
                  _ageField(),
                  SizedBox(height: kSeparation,),
                  _plateField(),
                  SizedBox(height: kSeparation*2,),
                  _submitButton(),
                  SizedBox(height: kSeparation*3,),
                ],
              ),
            ),
            SizedBox(height: size.height*0.2,)
          ],
        ),
      )
    );

  }

  Widget _submitButton(){
    return RaisedButton(
      child: Text('Registrar',style: TextStyle(color: Colors.white),),
      color: Colors.red,
      onPressed: (!_isSubmiting) ? () async {

        final FormState form = formKey.currentState;
        if(!form.validate()) return;

        form.save();

        final user = {
          "nombre": _nameController.text,
          "apellido": _lastNameController.text ,
          "telefono": int.parse(_phoneController.text),
          "vehiculos" : [
            {
              "marca"      : _vehicleController.text,
              "modelo"     : _modelController.text,
              "anho"       :  (_ageController!=null) ? int.parse(_ageController.text) : 0,
              "matricula"  : (_plateController.text!='') ? _plateController.text : null,
            }
          ]
        };

        setState(() {
          _isSubmiting=true;
        });
        await _firestore.addUser('Usuarios', user,_prefs.uid);
        Navigator.pushReplacementNamed(context, 'profile');


      } : null,
    );
  }

  Widget _makeField(BuildContext context){

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width*0.45 ,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: _vehicleController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.directions_car,color: Colors.black,),
          labelText: 'Marca',
        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese marca";
          else
            return null;
        },

      ),
    );
  }

  Widget _modelField(BuildContext context){

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width*0.35,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: _modelController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Modelo',
        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese modelo";
          else
            return null;
        },
      ),
    );
  }

  Widget _ageField(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today,color: Colors.black,),
          labelText: 'Año',
        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese el año del vehiculo";
          else
            return null;
        },

      ),
    );
  }

  Widget _plateField(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _plateController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.done,color: Colors.black,),
          labelText: 'Placa',
        ),

      ),
    );
  }

  Widget _nameField(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.person,color: Colors.black,),
          labelText: 'Nombre(s)',

        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese su nombre";
          else
            return null;
        },
      ),
    );
  }

  Widget _lastNameField(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _lastNameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(Icons.person,color: Colors.black,),
          labelText: 'Apellido(s)',
        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese su apellido";
          else
            return null;
        },
      ),
    );
  }

  Widget _phoneField(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          icon: Icon(Icons.phone_android,color: Colors.black,),
          labelText: 'Nro. telefono',
        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese su telefono";
          else
            return null;
        },
      ),
    );
  }

}
