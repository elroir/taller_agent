
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tallercall/src/services/user_prefs.dart';

class Database{

  final _firestore = Firestore.instance;

  final _prefs = UserPrefs();


  Future<String> mainCollectionAddData(String collection,Map<String,dynamic> data) async {
    DocumentReference document = await _firestore.collection(collection).add(data);
    _prefs.lastAppointment = document.documentID;
    return document.documentID;
  }

  Future<void> addUser(String collection,Map<String,dynamic> data,String uid) async {
    await _firestore.collection(collection).document(uid).setData(data);
  }

  Future<void> addVehicle(String collection,Map<String,dynamic> data,String uid) async {
    await _firestore.collection(collection).document(uid).updateData({  "vehiculos" : FieldValue.arrayUnion(['data'])  });
  }


  Stream<QuerySnapshot> getCollectionStream(String collection,List<String> query,String where)  {
    if(where==''||query.isEmpty){
      return _firestore.collection(collection).snapshots();
    }else
      return _firestore.collection(collection).where(where,arrayContainsAny: query).snapshots();
    }

  Future<DocumentSnapshot> getAppointment(String collection,String id)  {
    try{
      final stream = _firestore.collection(collection).document(id).get();
      return stream;
    }catch(e){
      print(e);
      return null;
    }

  }

  Stream<DocumentSnapshot> getUserStream(String collection,String id)  {
    try{
      final stream = _firestore.collection(collection).document(id).snapshots();
      return stream;
    }catch(e){
      print(e);
      return null;
    }

  }


}