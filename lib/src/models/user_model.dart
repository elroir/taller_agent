import 'dart:convert';

import 'package:tallercall/src/models/vehicle_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.nombre,
    this.apellido,
    this.telefono,
    this.vehiculos,
  });

  String nombre;
  String apellido;
  int telefono;
  List<VehicleModel> vehiculos;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    nombre: json["nombre"],
    apellido: json["apellido"],
    telefono: json["telefono"],
    vehiculos: List<VehicleModel>.from(json["vehiculos"].map((x) => VehicleModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "apellido": apellido,
    "telefono": telefono,
    "vehiculos": List<dynamic>.from(vehiculos.map((x) => x.toJson())),
  };
}
