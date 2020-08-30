import 'package:firebase_auth/firebase_auth.dart';
import 'package:tallercall/src/services/user_prefs.dart';

class AuthService {
  static AuthService _instance = AuthService();
  static AuthService get instance => _instance;

  final _prefs = new UserPrefs();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      _prefs.uid = user.uid;
      return {"ok": true, "token": _prefs.uid};
    } catch (e) {
      String error = e.toString();
      return {"ok": false, "mensaje": error};
    }
  }

  // MUST USE THIS FUNCT
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        _prefs.token = (await result.user.getIdToken());
        _prefs.uid = result.user.uid;
        _prefs.email = result.user.email;
      }
      return {"ok": true, "token": _prefs.token};
    } catch (e) {
      String error = e.toString();
      return {"ok": false, "mensaje": error};
    }
  }

  Future<Map<String, dynamic>> deleteUser() async {
    try {
      User user = _auth.currentUser;
      user.delete();
      return {"ok": true, "token": _prefs.token};
    } catch (e) {
      List<String> list = e.toString().split(',');
      String error = list.first.replaceAll('PlatformException(', '');
      return {"ok": false, "mensaje": error};
    }
  }

  Future<User> get currentUser async {
    return _auth.currentUser;
  }

  Future<void> sendEmailVerification() async {
    User user = _auth.currentUser;
    return user.sendEmailVerification();
  }

  Future<void> signOut() async => _auth.signOut();

  Future<bool> isEmailVerified() async {
    User user =  _auth.currentUser;
    return user.emailVerified;
  }
}
