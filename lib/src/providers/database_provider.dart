
import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  final _firestore = FirebaseFirestore.instance;


  Future<void> mainCollectionAddData(String collection,Map<String,dynamic> data) async {
    _firestore.collection(collection).add(data);
  }

  Future<void> addUser(String collection,Map<String,dynamic> data,String uid) async {
    await _firestore.collection(collection).doc(uid).set(data);
  }

  Future<void> addVehicle(String collection,Map<String,dynamic> data,String uid) async {
    await _firestore.collection(collection).doc(uid).update({  "vehiculos" : FieldValue.arrayUnion(['data'])  });
  }

  Stream<QuerySnapshot> getCollectionStream(String collection,List<String> query,String where)  {
    if(where==''||query.isEmpty){
      return _firestore.collection(collection).snapshots();
    }else
      return _firestore.collection(collection).where(where,arrayContainsAny: query).snapshots();
    }

  Stream<DocumentSnapshot> getUserStream(String collection,String id)  {
    try{
      final stream = _firestore.collection(collection).doc(id).snapshots();
      return stream;
    }catch(e){
      print(e);
      return null;
    }

  }


}