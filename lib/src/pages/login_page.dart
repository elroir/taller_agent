import 'package:flutter/material.dart';
import 'package:tallercall/src/services/auth.dart';
import 'package:tallercall/src/widgets/custom_square.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  TextEditingController _email = new TextEditingController();

  TextEditingController _password = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,elevation: 0.0,
        actions: [
          FlatButton(
            child: Icon(Icons.home,color: Colors.white,),
            onPressed: () => Navigator.pushReplacementNamed(context, 'home'),
          )
        ],
      ),

      body: Stack(
        children: [
          CustomSquare(),
          _loginForm(context),
        ],
      ),

    );
  }

  Widget _loginForm(BuildContext context){

    final size = MediaQuery.of(context).size;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Container(
                height: 50.0,
              ),
            ),
            Container(
              width: size.width*0.85,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 50.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0,5.0),
                    spreadRadius: 3.0

                  )
                ]
              ),
              child: Column(
                children: [
                  Text('Ingreso',style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: 60.0),
                  _createEmail(),
                  SizedBox(height: 30.0),
                  _createPassword(),
                  SizedBox(height: 30.0),
                  _createButton(context)
                ],
              ),
            ),
            FlatButton(
              child: Text('Crear una nueva cuenta'),
              onPressed: () => Navigator.pushNamed(context, 'register'),
            ),
            SizedBox(height: 100.0,)
          ],
        ),
      ),
    );
  }

  Widget _createEmail() {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email,color: Colors.red,),
              labelText: 'Correo electronico',
            ),
            validator: (value){
              if(value.length <= 0)
                return "Ingrese un correo";
              else
                return null;
            },
          ),
        );


  }

  Widget _createPassword() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _password,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline,color: Colors.red,),
          labelText: 'Contraseña',
        ),
        validator: (value){
          if(value.length <= 0)
            return "Ingrese una contraseña";
          else
            return null;
        },

      ),
    );
  }

  Widget _createButton(BuildContext context){

    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
      ),
      elevation: 0.0,
      color: Colors.red,
      textColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0,vertical: 15.0),
        child: Text('Ingresar'),
      ),
      onPressed: () => _login(context)
    );


  }

  _login(BuildContext context) async {
    final FormState form = formKey.currentState;
    if(!form.validate()) return;

    form.save();

    Map info = await _auth.signIn(_email.text, _password.text);
    if( info['ok']) {
      Navigator.pushReplacementNamed(context, 'profile');
    } else {
      _showAlert(context, info['mensaje']);
    }


  }

  void _showAlert (BuildContext context,String message) {

    switch(message){
      case '[firebase_auth/invalid-email] The email address is badly formatted.' : {
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Correo electronico no valido') ,
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
      break;

      case 'ERROR_WRONG_PASSWORD' : {
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Contraseña Incorrecta') ,
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
      break;

    }

  }

}