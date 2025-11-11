// To parse this JSON data, do
//
//     final getUserProfileModel = getUserProfileModelFromJson(jsonString);

import 'dart:convert';

GetUserProfileModel getUserProfileModelFromJson(String str) => GetUserProfileModel.fromJson(json.decode(str));

String getUserProfileModelToJson(GetUserProfileModel data) => json.encode(data.toJson());

class GetUserProfileModel {
    final bool? success;
    final Data? data;

    GetUserProfileModel({
        this.success,
        this.data,
    });

    factory GetUserProfileModel.fromJson(Map<String, dynamic> json) => GetUserProfileModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    final String? id;
    final String? userName;
    final String? mobileNumber;
    final String? countryCode;
    final int? spacesCount;
    final List<Space>? spaces;
    final DateTime? createdAt;
    final DateTime? lastLogin;
    final bool? isActive;

    Data({
        this.id,
        this.userName,
        this.mobileNumber,
        this.countryCode,
        this.spacesCount,
        this.spaces,
        this.createdAt,
        this.lastLogin,
        this.isActive,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userName: json["user_name"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        spacesCount: json["spaces_count"],
        spaces: json["spaces"] == null ? [] : List<Space>.from(json["spaces"]!.map((x) => Space.fromJson(x))),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "spaces_count": spacesCount,
        "spaces": spaces == null ? [] : List<dynamic>.from(spaces!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "last_login": lastLogin?.toIso8601String(),
        "is_active": isActive,
    };
}

class Space {
    final String? spaceId;
    final String? spaceName;
    final Devices? devices;

    Space({
        this.spaceId,
        this.spaceName,
        this.devices,
    });

    factory Space.fromJson(Map<String, dynamic> json) => Space(
        spaceId: json["space_id"],
        spaceName: json["space_name"],
        devices: json["devices"] == null ? null : Devices.fromJson(json["devices"]),
    );

    Map<String, dynamic> toJson() => {
        "space_id": spaceId,
        "space_name": spaceName,
        "devices": devices?.toJson(),
    };
}

class Devices {
    final int? total;
    final int? base;
    final int? tank;

    Devices({
        this.total,
        this.base,
        this.tank,
    });

    factory Devices.fromJson(Map<String, dynamic> json) => Devices(
        total: json["total"],
        base: json["base"],
        tank: json["tank"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "base": base,
        "tank": tank,
    };
}
