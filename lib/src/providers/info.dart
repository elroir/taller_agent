
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';


class Info with ChangeNotifier {

  String _sstText = 'hola';
  String _response = '';
  String _intent = '';
  String _email = '';
  bool _appointment =  false;
  QueryResult _queryResult;


  QueryResult get queryResult {
    return _queryResult;
  }

  set queryResult(QueryResult query) {
    this._queryResult = query;
    notifyListeners();
  }

  String get email {
    return _email;
  }

  set email(String text) {
    this._email = text;
    notifyListeners();
  }


  String get sstText {
    return _sstText;
  }

  set sstText(String text) {
    this._sstText = text;
    notifyListeners();
  }

  get response {
    return _response;
  }

  set response(String text) {
    this._response = text;
    notifyListeners();
  }

  get appointment {
    return _appointment;
  }

  set appointment(bool text) {
    this._appointment = text;
    notifyListeners();
  }

  get intent {
    return _intent;
  }

  set intent(String text) {
    this._intent = text;
    notifyListeners();
  }

}