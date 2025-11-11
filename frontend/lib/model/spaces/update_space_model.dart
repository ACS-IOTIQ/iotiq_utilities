// To parse this JSON data, do
//
//     final updateSpaceModel = updateSpaceModelFromJson(jsonString);

import 'dart:convert';

UpdateSpaceModel updateSpaceModelFromJson(String str) => UpdateSpaceModel.fromJson(json.decode(str));

String updateSpaceModelToJson(UpdateSpaceModel data) => json.encode(data.toJson());

class UpdateSpaceModel {
    final bool success;
    final Data data;
    final String message;

    UpdateSpaceModel({
        required this.success,
        required this.data,
        required this.message,
    });

    factory UpdateSpaceModel.fromJson(Map<String, dynamic> json) => UpdateSpaceModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    final String id;
    final String spaceName;
    final String address;
    final List<dynamic> devices;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.spaceName,
        required this.address,
        required this.devices,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        spaceName: json["space_name"],
        address: json["address"],
        devices: List<dynamic>.from(json["devices"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "space_name": spaceName,
        "address": address,
        "devices": List<dynamic>.from(devices.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
