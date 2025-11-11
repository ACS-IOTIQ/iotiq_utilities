// To parse this JSON data, do
//
//     final getAllSpacesModel = getAllSpacesModelFromJson(jsonString);

import 'dart:convert';

GetAllSpacesModel getAllSpacesModelFromJson(String str) => GetAllSpacesModel.fromJson(json.decode(str));

String getAllSpacesModelToJson(GetAllSpacesModel data) => json.encode(data.toJson());

class GetAllSpacesModel {
    final bool success;
    final List<GetAllSpacesDataModel> data;

    GetAllSpacesModel({
        required this.success,
        required this.data,
    });

    factory GetAllSpacesModel.fromJson(Map<String, dynamic> json) => GetAllSpacesModel(
        success: json["success"],
        data: List<GetAllSpacesDataModel>.from(json["data"].map((x) => GetAllSpacesDataModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class GetAllSpacesDataModel {
    final String spaceName;
    final String address;
    final List<dynamic> devices;
    final DateTime createdAt;
    final String id;

    GetAllSpacesDataModel({
        required this.spaceName,
        required this.address,
        required this.devices,
        required this.createdAt,
        required this.id,
    });

    factory GetAllSpacesDataModel.fromJson(Map<String, dynamic> json) => GetAllSpacesDataModel(
        spaceName: json["space_name"],
        address: json["address"],
        devices: List<dynamic>.from(json["devices"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "space_name": spaceName,
        "address": address,
        "devices": List<dynamic>.from(devices.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "_id": id,
    };
}
