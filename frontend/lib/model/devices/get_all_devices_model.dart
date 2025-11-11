// To parse this JSON data, do
//
//     final getAllDevicesModel = getAllDevicesModelFromJson(jsonString);

import 'dart:convert';

GetAllDevicesModel getAllDevicesModelFromJson(String str) => GetAllDevicesModel.fromJson(json.decode(str));

String getAllDevicesModelToJson(GetAllDevicesModel data) => json.encode(data.toJson());

class GetAllDevicesModel {
    final bool success;
    final List<Datum> data;

    GetAllDevicesModel({
        required this.success,
        required this.data,
    });

    factory GetAllDevicesModel.fromJson(Map<String, dynamic> json) => GetAllDevicesModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
  final String? deviceId;
  final String? deviceType;
  final String? deviceName;
  final String? connectionType;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? spaceId;
  final String? spaceName;
  final String? ssid;
  final String? password;

  Datum({
    this.deviceId,
    this.deviceType,
    this.deviceName,
    this.connectionType,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.spaceId,
    this.spaceName,
    this.ssid,
    this.password,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        deviceId: json["device_id"]?.toString(),
        deviceType: json["device_type"]?.toString(),
        deviceName: json["device_name"]?.toString(),
        connectionType: json["connection_type"]?.toString(),
        id: json["_id"]?.toString(),
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        spaceId: json["space_id"]?.toString(),
        spaceName: json["space_name"]?.toString(),
        ssid: json["ssid"]?.toString(),
        password: json["password"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "device_type": deviceType,
        "device_name": deviceName,
        "connection_type": connectionType,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "space_id": spaceId,
        "space_name": spaceName,
        "ssid": ssid,
        "password": password,
      };
}


