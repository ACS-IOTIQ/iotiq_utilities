// To parse this JSON data, do
//
//     final baseSensorsModel = baseSensorsModelFromJson(jsonString);

import 'dart:convert';

BaseSensorsModel baseSensorsModelFromJson(String str) => BaseSensorsModel.fromJson(json.decode(str));

String baseSensorsModelToJson(BaseSensorsModel data) => json.encode(data.toJson());

class BaseSensorsModel {
    bool? success;
    List<Datum>? data;

    BaseSensorsModel({
        this.success,
        this.data,
    });

    factory BaseSensorsModel.fromJson(Map<String, dynamic> json) => BaseSensorsModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? thingid;
    String? deviceid;
    DateTime? timestamp;
    String? messageType;
    String? switchNo;
    String? status;
    dynamic sensorNo;
    dynamic value;

    Datum({
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        thingid: json["thingid"],
        deviceid: json["deviceid"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        messageType: json["message_type"],
        switchNo: json["switch_no"],
        status: json["status"],
        sensorNo: json["sensor_no"],
        value: json["value"],
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
