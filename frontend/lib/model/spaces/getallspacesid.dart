// To parse this JSON data, do
//
//     final getAllSpaceModelId = getAllSpaceModelIdFromJson(jsonString);
import 'dart:convert';

GetAllSpaceModelId getAllSpaceModelIdFromJson(String str) => GetAllSpaceModelId.fromJson(json.decode(str));

String getAllSpaceModelIdToJson(GetAllSpaceModelId data) => json.encode(data.toJson());

class GetAllSpaceModelId {
    final bool success;
    final Data data;

    GetAllSpaceModelId({
        required this.success,
        required this.data,
    });

    factory GetAllSpaceModelId.fromJson(Map<String, dynamic> json) => GetAllSpaceModelId(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    final String id;
    final String spaceName;
    final String address;
    final List<dynamic> devices;
    final DateTime createdAt;

    Data({
        required this.id,
        required this.spaceName,
        required this.address,
        required this.devices,
        required this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        spaceName: json["space_name"],
        address: json["address"],
        devices: List<dynamic>.from(json["devices"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "space_name": spaceName,
        "address": address,
        "devices": List<dynamic>.from(devices.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
    };
}
