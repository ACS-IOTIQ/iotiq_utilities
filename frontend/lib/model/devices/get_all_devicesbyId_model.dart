// To parse this JSON data, do
//
//     final getAllDevicesBySpaceIdModel = getAllDevicesBySpaceIdModelFromJson(jsonString);

import 'dart:convert';

GetAllDevicesBySpaceIdModel getAllDevicesBySpaceIdModelFromJson(String str) =>
    GetAllDevicesBySpaceIdModel.fromJson(json.decode(str));

String getAllDevicesBySpaceIdModelToJson(GetAllDevicesBySpaceIdModel data) =>
    json.encode(data.toJson());

class GetAllDevicesBySpaceIdModel {
  final bool success;
  final Data data;

  GetAllDevicesBySpaceIdModel({required this.success, required this.data});

  factory GetAllDevicesBySpaceIdModel.fromJson(Map<String, dynamic> json) =>
      GetAllDevicesBySpaceIdModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": data.toJson()};
}

class Data {
  final String spaceName;
  final String address;
  final List<Device> devices;
  final dynamic setup;
  final DateTime createdAt;
  final String id;
  final List<dynamic> setups;

  Data({
    required this.spaceName,
    required this.address,
    required this.devices,
    required this.setup,
    required this.createdAt,
    required this.id,
    required this.setups,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    spaceName: json["space_name"],
    address: json["address"],
    devices: List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
    setup: json["setup"],
    createdAt: DateTime.parse(json["created_at"]),
    id: json["_id"],
    setups: List<dynamic>.from(json["setups"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "space_name": spaceName,
    "address": address,
    "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
    "setup": setup,
    "created_at": createdAt.toIso8601String(),
    "_id": id,
    "setups": List<dynamic>.from(setups.map((x) => x)),
  };
}

class Device {
  final bool onlineStatus;
  final String deviceId;
  final String deviceType;
  final String deviceName;
  final String connectionType;
  final String parentDeviceId;
  final String? ssid; // nullable
  final String? password; // nullable
  final String id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastUpdated;
  final int level;
  final String switchNo;
  final String addressL;
  final String slaveName;
  final String addressH;
  final String channel;

  Device({
    required this.onlineStatus,
    required this.deviceId,
    required this.deviceType,
    required this.deviceName,
    required this.connectionType,
    required this.parentDeviceId,
    this.ssid,
    this.password,
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.lastUpdated,
    required this.level,
    required this.switchNo,
    required this.addressL,
    required this.slaveName,
    required this.addressH,
    required this.channel,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    onlineStatus: json["online_status"] ?? false,
    deviceId: json["device_id"] ?? '',
    deviceType: json["device_type"] ?? '',
    deviceName: json["device_name"] ?? '',
    connectionType: json["connection_type"] ?? '',
    ssid: json["ssid"], // nullable, no default
    password: json["password"], // nullable, no default
    id: json["_id"] ?? '',
    parentDeviceId: json["parent_device_id"] ?? '',
    status: json["status"] ?? '', // safeguard null with empty string
    createdAt: DateTime.parse(
      json["createdAt"] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json["updatedAt"] ?? DateTime.now().toIso8601String(),
    ),
    lastUpdated: DateTime.parse(
      json["last_updated"] ?? DateTime.now().toIso8601String(),
    ),
    level: json["level"] ?? 0,
    switchNo: json["switch_no"] ?? '',
    addressL: json["addl"] ?? '',
    slaveName: json["slave_name"] ?? '',
    addressH: json["addh"] ?? '',
    channel: json["channel"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "online_status": onlineStatus,
    "device_id": deviceId,
    "device_type": deviceType,
    "device_name": deviceName,
    "connection_type": connectionType,
    "ssid": ssid,
    "password": password,
    "_id": id,
    "parent_device_id": parentDeviceId,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "last_updated": lastUpdated.toIso8601String(),
    "level": level,
    "switch_no": switchNo,
    "addl": addressL,
    "slave_name": slaveName,
    "addh": addressH,
    "channel": channel,
  };
}
