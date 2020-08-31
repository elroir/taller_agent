// To parse this JSON data, do
//
//     final appointmentModel = appointmentModelFromJson(jsonString);

import 'dart:convert';

AppointmentModel appointmentModelFromJson(String str) => AppointmentModel.fromJson(json.decode(str));

String appointmentModelToJson(AppointmentModel data) => json.encode(data.toJson());

class AppointmentModel {
  AppointmentModel({
    this.estado,
    this.fecha,
    this.descripcion,
    this.hora,
    this.usuario,
  });

  String estado;
  String fecha;
  String descripcion;
  String hora;
  String usuario;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    estado: json["estado"],
    fecha: json["fecha"],
    descripcion: json["descripcion"],
    hora: json["hora"],
    usuario: json["usuario"],
  );

  Map<String, dynamic> toJson() => {
    "estado": estado,
    "fecha": fecha,
    "descripcion": descripcion,
    "hora": hora,
    "usuario": usuario,
  };
}
