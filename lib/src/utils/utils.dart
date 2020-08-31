
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int getWeekday(String day){

    DateTime date = DateTime.now();

    int today = 0;

    switch(day){
      case 'lunes':
        today = 1;
      break;
      case 'martes':
        today = 2;
        break;
      case 'miercoles':
        today = 3;
        break;
      case 'jueves':
        today = 4;
        break;
      case 'viernes':
        today = 5;
        break;
      case 'sabado':
        today = 6;
        break;
      case 'domingo':
        today = 7;
        break;
      default:
        today = 0;
        break;
    }

    if (today>=date.weekday)
      return (date.weekday+7) - today;
    else
      return date.weekday - today;

  }

  void createSimpleDialog(BuildContext context,String title,String content){
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

