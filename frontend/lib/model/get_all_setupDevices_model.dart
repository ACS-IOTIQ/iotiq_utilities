// To parse this JSON data, do
//
//     final getAllSetupDevicesModel = getAllSetupDevicesModelFromJson(jsonString);

import 'dart:convert';

GetAllSetupDevicesModel getAllSetupDevicesModelFromJson(String str) =>
    GetAllSetupDevicesModel.fromJson(json.decode(str));

String getAllSetupDevicesModelToJson(GetAllSetupDevicesModel data) =>
    json.encode(data.toJson());

class GetAllSetupDevicesModel {
  final bool? success;
  final List<Datum>? data;
  final String? message;

  GetAllSetupDevicesModel({this.success, this.data, this.message});

  factory GetAllSetupDevicesModel.fromJson(Map<String, dynamic> json) =>
      GetAllSetupDevicesModel(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  final String? id;
  final String? name;
  final String? description;
  final Condition? condition;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.description,
    this.condition,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    condition: json["condition"] == null
        ? null
        : Condition.fromJson(json["condition"]),
    active: json["active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "condition": condition?.toJson(),
    "active": active,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Condition {
  final String? deviceId;
  final String? deviceName;
  final String? deviceType;
  final List<Action>? actions;
  final int? level;
  final int? minimum;
  final int? maximum;
  final String? conditionOperator;
  final String? status;
  final String? switchNo;

  Condition({
    this.deviceId,
    this.deviceName,
    this.deviceType,
    this.actions,
    this.level,
    this.minimum,
    this.maximum,
    this.conditionOperator,
    this.status,
    this.switchNo,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
    deviceId: json["device_id"],
    deviceName: json["device_name"],
    deviceType: json["device_type"],
    actions: json["actions"] == null
        ? []
        : List<Action>.from(json["actions"]!.map((x) => Action.fromJson(x))),
    level: json["level"],
    minimum: json["minimum"],
    maximum: json["maximum"],
    conditionOperator: json["operator"],
    status: json["status"],
    switchNo: json["switch_no"],
  );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "device_name": deviceName,
    "device_type": deviceType,
    "actions": actions == null
        ? []
        : List<dynamic>.from(actions!.map((x) => x.toJson())),
    "level": level,
    "minimum": minimum,
    "maximum": maximum,
    "operator": conditionOperator,
    "status": status,
    "switch_no": switchNo,
  };
}

class Action {
  final String? deviceId;
  final String? deviceName;
  final String? switchNo;
  final String? setStatus;
  final int? delay;

  Action({
    this.deviceId,
    this.deviceName,
    this.switchNo,
    this.setStatus,
    this.delay,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
    deviceId: json["device_id"],
    deviceName: json["device_name"],
    switchNo: json["switch_no"],
    setStatus: json["set_status"],
    delay: json["delay"],
  );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "device_name": deviceName,
    "switch_no": switchNo,
    "set_status": setStatus,
    "delay": delay,
  };
}
