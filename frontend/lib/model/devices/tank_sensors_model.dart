// To parse this JSON data, do
//
//     final tankSensorsModel = tankSensorsModelFromJson(jsonString);

import 'dart:convert';

TankSensorsModel tankSensorsModelFromJson(String str) =>
    TankSensorsModel.fromJson(json.decode(str));

String tankSensorsModelToJson(TankSensorsModel data) =>
    json.encode(data.toJson());

class TankSensorsModel {
  bool? success;
  List<TankDatum>? data;

  TankSensorsModel({this.success, this.data});

  factory TankSensorsModel.fromJson(Map<String, dynamic> json) =>
      TankSensorsModel(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<TankDatum>.from(
                json["data"]!.map((x) => TankDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TankDatum {
  int? id;
  String? thingid;
  String? deviceid;
  DateTime? timestamp;
  String? messageType;
  String? switchNo;
  String? status;
  String? sensorNo;
  int? value;

  TankDatum({
    this.id,
    this.thingid,
    this.deviceid,
    this.timestamp,
    this.messageType,
    this.switchNo,
    this.status,
    this.sensorNo,
    this.value,
  });

  factory TankDatum.fromJson(Map<String, dynamic> json) => TankDatum(
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? ''),
        thingid: json["thingid"],
        deviceid: json["deviceid"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.tryParse(json["timestamp"].toString()),
        messageType: json["message_type"],
        switchNo: json["switch_no"],
        status: json["status"],
        sensorNo: json["sensor_no"],
        // 👇 FIX: safely handle string or int for `value`
        value: json["value"] is int
            ? json["value"]
            : int.tryParse(json["value"]?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "thingid": thingid,
        "deviceid": deviceid,
        "timestamp": timestamp?.toIso8601String(),
        "message_type": messageType,
        "switch_no": switchNo,
        "status": status,
        "sensor_no": sensorNo,
        "value": value,
      };
}
