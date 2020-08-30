// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

VehicleModel vehicleModelFromJson(String str) => VehicleModel.fromJson(json.decode(str));

String vehicleModelToJson(VehicleModel data) => json.encode(data.toJson());

class VehicleModel {
  VehicleModel({
    this.marca,
    this.modelo,
    this.anho,
    this.matricula,
    this.vin,
  });

  String marca;
  String modelo;
  int anho;
  String matricula;
  String vin;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    marca: json["marca"],
    modelo: json["modelo"],
    anho: json["anho"],
    matricula: json["matricula"],
    vin: json["vin"],
  );

  Map<String, dynamic> toJson() => {
    "marca": marca,
    "modelo": modelo,
    "anho": anho,
    "matricula": matricula,
    "vin": vin,
  };
}