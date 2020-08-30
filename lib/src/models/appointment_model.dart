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
    this.hora,
  });

  String estado;
  String fecha;
  String hora;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    estado: json["estado"],
    fecha: json["fecha"],
    hora: json["hora"],
  );

  Map<String, dynamic> toJson() => {
    "estado": estado,
    "fecha": fecha,
    "hora": hora,
  };
}
