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
      FirebaseUser user = result.user;
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
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        _prefs.token = (await result.user.getIdToken()).token;
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
      FirebaseUser user = await _auth.currentUser();
      user.delete();
      return {"ok": true, "token": _prefs.token};
    } catch (e) {
      List<String> list = e.toString().split(',');
      String error = list.first.replaceAll('PlatformException(', '');
      return {"ok": false, "mensaje": error};
    }
  }

  Future<FirebaseUser> get currentUser async {
    return await _auth.currentUser();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _auth.currentUser();
    return user.sendEmailVerification();
  }

  Future<void> signOut() async => _auth.signOut();

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }
}
