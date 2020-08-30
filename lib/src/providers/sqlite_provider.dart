import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tallercall/src/models/appointment_model.dart';

class SQLProvider {

  static Database _database;
  static final SQLProvider db = SQLProvider._();

  SQLProvider._();

  Future<Database> get database async {

    if ( _database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'AppCV19DB.db');

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Cita ('
                  ' id INTEGER PRIMARY KEY,'
                  ' estado TEXT,'
                  ' fecha TEXT,'
                  ' hora TEXT'
                  ')'
          );
          await db.rawInsert("INSERT into Cita(id,estado,fecha,hora) "
              "VALUES (0,'','',null)"
          );
        }
    );
  }


  newAppointment(AppointmentModel newInfo) async {
    final db = await database;

    final res = await db.insert('Cita', newInfo.toJson());

    return res;
  }

  Future<AppointmentModel> getAppointment() async {

    final db = await database;
    final res = await db.query('Cita');
    print(res);
    if(res.isEmpty){
      return null;
    }else
      return AppointmentModel.fromJson(res.first);

  }

  //Actualizar
  Future<int> updateAppointment(AppointmentModel newCita) async {
    final db = await database ;

    final res = await db.update('Persona',newCita.toJson() );
    return res;
  }

}