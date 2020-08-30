import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {

  static final UserPrefs _instance = new UserPrefs._internal();

  factory UserPrefs() {
    return _instance;
  }

  UserPrefs._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get hour {
    return _prefs.getString('hour') ?? '';
  }

  set hour( String value ) {
    _prefs.setString('hour', value);
  }

  get minutes {
    return _prefs.getString('minutes') ?? '';
  }

  set minutes( String value ) {
    _prefs.setString('minutes', value);
  }

  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }


  get uid{
    return _prefs.getString('uid') ?? '';
  }

  set uid( String value ) {
    _prefs.setString('uid', value);
  }

  get email{
    return _prefs.getString('email') ?? '';
  }

  set email( String value ) {
    _prefs.setString('email', value);
  }

  get lastPage{
    return _prefs.getString('lastPage') ?? 'home';
  }

  set lastPage( String value ) {
    _prefs.setString('lastPage', value);
  }

}