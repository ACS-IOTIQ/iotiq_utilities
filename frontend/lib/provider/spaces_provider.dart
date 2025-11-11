// ignore_for_file: cast_from_null_always_fails, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility/model/devices/base_sensors_model.dart';
import 'package:utility/model/devices/get_all_devices_model.dart' hide Datum;
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/model/devices/tank_sensors_model.dart';
import 'package:utility/model/get_all_setupDevices_model.dart' hide Datum;
import 'package:utility/model/spaces/get_all_spaces.dart';
import 'package:utility/model/spaces/update_space_model.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/token_http_client.dart' show TokenAwareHttpClient;
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/ui/space/add_device.dart';
import 'package:utility/utils/custom_toast.dart';

class SpacesProvider extends ChangeNotifier {
  static const String baseUrl = 'https://api.iotiq.co.in';
  // static const String baseUrl = 'https://utilityiot.onrender.com';

  List<GetAllSpacesModel> getAllSpacesModel = [];
  List<GetAllSpacesDataModel> getAllSpacesData = [];
  List<GetAllSetupDevicesModel> getAllSetupDevice = [];
  GetAllDevicesBySpaceIdModel? getAllDevicesByIdModel;
  bool? isLoading = true;
  var spaceId;

  final TextEditingController wifiNameContoller = TextEditingController();
  final TextEditingController wifiPasswordContoller = TextEditingController();

  String? selectedSpaceId;
  String? selectedDeviceId;

  /// stroing the spaceId and deviceId
  void setSelectedSpaceAndDevice(String spaceId) {
    selectedSpaceId = spaceId;
    notifyListeners();
  }

  GetAllSpacesDataModel? get selectedSpace {
    if (selectedSpaceId == null) return null;

    return getAllSpacesData.firstWhere(
      (space) => space.id == selectedSpaceId,
      orElse: () => getAllSpacesData.isNotEmpty
          ? getAllSpacesData.first
          : null as GetAllSpacesDataModel,
    );
  }

  bool _isCreateSpaceLoading = false;
  bool get isCreateSpaceLoading => _isCreateSpaceLoading;

  void setCreateSpaceLoading(bool val) {
    _isCreateSpaceLoading = val;
    notifyListeners();
  }

  /// create space
  Future<void> createSpace({
    required String spaceName,
    required String address,
    required BuildContext context,
  }) async {
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;
    final url = Uri.parse(
      '$baseUrl/spaces',
    ); // Replace with your actual API base URL
    final response = await TokenAwareHttpClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "space_name": spaceName,
        "address": address,
        "devices": [], // Add devices here if needed
      }),
      context: context,
    );
    setCreateSpaceLoading(true);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Space created: ${response.body}');
      final data = jsonDecode(response.body);
      spaceId = data['data']['_id'];
      print("ghghgh $spaceId");
      CustomToast.showSuccessToast(msg: "${data['message']}").then((value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setCreateSpaceLoading(false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDeviceScreen()),
          );
        });
      });
    } else {
      print('Failed to create space: ${response.statusCode}');
      setCreateSpaceLoading(false);

      final data = jsonDecode(response.body);
      CustomToast.showErrorToast(msg: "${data['message']}");
      print('Response: ${response.body}');
    }
  }

  Future<void> controllerBaseDevices({
    required String deviceId,
    required String status,
    required String switchNo,
    required BuildContext context,
  }) async {
    try {
      final token = Provider.of<CommonProvider>(
        listen: false,
        context,
      ).accessToken;

      final url = Uri.parse('$baseUrl/publish');

      final body = jsonEncode({
        "deviceid": deviceId,
        "switch_no": switchNo,

        "status": status,
      });

      print('Sending device control: $body');

      final response = await TokenAwareHttpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // 🔍 Add content-type for JSON
        },
        body: body,
        context: context,
      );

      print("Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        // Optionally handle success
        print("Device control successful.");
      } else {
        throw Exception('Failed to control device: ${response.body}');
      }
    } catch (e) {
      print("Error controlling device: $e");
      CustomToast.showErrorToast(
        msg: "Device control failed. Please try again.",
      );
    }
    notifyListeners();
  }

  Future<GetAllSpacesModel?> fetchSpaces(BuildContext context) async {
  final provider = Provider.of<CommonProvider>(context, listen: false);
  String token = provider.accessToken;

  if (token.isEmpty) {
    print("⛔ Token is empty. Skipping space fetch.");
    return null;
  }

  final uri = Uri.parse("$baseUrl/spaces");
  try {
    final response = await TokenAwareHttpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.statusCode == 200) {
      return getAllSpacesModelFromJson(response.body);
    } else if (response.statusCode == 401) {
      // Unauthorized - try refreshing token once
      print('Token expired or invalid, refreshing...');
      final refreshed = await provider.refreshAccessToken(context);
      if (refreshed) {
        // retry with new token
        token = provider.accessToken;
        final retryResponse = await TokenAwareHttpClient.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          context: context,
        );

        if (retryResponse.statusCode == 200) {
          return getAllSpacesModelFromJson(retryResponse.body);
        }
      }
      print('Failed to load spaces after token refresh: ${response.statusCode}');
      print(response.body);
      return null;
    } else {
      print('Failed to load spaces: ${response.statusCode}');
      print(response.body);
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}


  /// get all devices
  Future<GetAllDevicesModel> fetchDevices(
    String userId,
    BuildContext context,
  ) async {
    final url = Uri.parse('$baseUrl/users/$userId/devices');
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;
    final response = await TokenAwareHttpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      context: context,
    );
    if (response.statusCode == 200) {
      print("get all devices ${response.body}");
      final responseData = jsonDecode(response.body);

      print("print device name ${responseData['device_type']}");
      return getAllDevicesModelFromJson(response.body);
    } else {
      throw Exception('Failed to load devices: ${response.statusCode}');
    }
  }

  Future<GetAllDevicesBySpaceIdModel?> getDevicesBySpaceId(
    BuildContext context,
  ) async {
    final url = Uri.parse('$baseUrl/spaces/$selectedSpaceId');
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;

    isLoading = false;

    try {
      final response = await TokenAwareHttpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        context: context,
      );

      if (response.statusCode == 200) {
        print("devices resonse body: ${response.body}");
        final responseData = jsonDecode(response.body);
        // print("object ${responseData['data'][3]['_id']}");
        return getAllDevicesBySpaceIdModelFromJson(response.body);
      } else {
        print('Failed to load spaces: ${response.statusCode}');
        initializeDefaultSpace(context);
        print(response.body);
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<void> refreshSpaces(BuildContext context) async {
    final model = await fetchSpaces(context);
    if (model != null) {
      getAllSpacesModel = model.data.cast<GetAllSpacesModel>();
      notifyListeners();
    }
  }

  bool _isAddDeviceWifiLoading = false;
  bool get isAddDeviceWifiLoading => _isAddDeviceWifiLoading;

  void setAddDeviceLoading(bool val) {
    _isAddDeviceWifiLoading = val;
    notifyListeners();
  }

  Future<void> addDeviceWithWifiBase({
    required String deviceType,
    required String ssid,
    required String password,
    required String deviceId,
    required String thingId,  
    required String deviceName,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    final url = Uri.parse('$baseUrl/spaces/$selectedSpaceId/devices');
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "device_id": deviceId,
      "device_type": deviceType,
      "device_name": deviceName.isEmpty ? "Base Module 4" : deviceName,
      "connection_type": "wifi",
      "ssid": ssid,
      "password": password,
      "thing_name": thingId,
      "status": "on",
    });
    setAddDeviceLoading(true);
    try {
      final response = await TokenAwareHttpClient.post(
        url,
        headers: headers,
        body: body,
        context: context,
      );

      print("response body $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final success = data['success'];
        final message = data['message'];
        if (success == true) {
          CustomToast.showSuccessToast(msg: "$message");
          onSuccess(); // Call navigation
        } else {
          CustomToast.showErrorToast(msg: "$message");
        }
      } else {
        print('Failed to add device. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final data = jsonDecode(response.body);
        final message = data['message'];

        CustomToast.showErrorToast(msg: "$message");
        setAddDeviceLoading(false);
      }
    } catch (e) {
      print('Error occurred: $e');
      CustomToast.showErrorToast(msg: "$e");
      setAddDeviceLoading(false);
    }
  }

  bool _isAddDeviceWithoutWifiLoading = false;
  bool get isAddDeviceWithoutWifiLoading => _isAddDeviceWithoutWifiLoading;

  void setAddDeviceWithoutLoading(bool val) {
    _isAddDeviceWithoutWifiLoading = val;
    notifyListeners();
  }

  /// edit or update the space
  Future<UpdateSpaceModel> updateSpace(
    String id,
    String name,
    String address,
    BuildContext context,
  ) async {
    final url = Uri.parse('$baseUrl/spaces/$id');
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;

    final response = await TokenAwareHttpClient.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'space_name': name, 'address': address}),
      context: context,
    );

    if (response.statusCode == 200) {
      print("object update data ${response.body}");
      final data = jsonDecode(response.body);
      CustomToast.showSuccessToast(msg: "${data['message']}");

      return updateSpaceModelFromJson(response.body);
    } else {
      throw Exception('Failed to update space: ${response.body}');
    }
  }

  /// delete the space
  Future<bool> deleteSpace(String id, BuildContext context) async {
    final url = Uri.parse('$baseUrl/spaces/$id');
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;

    final response = await TokenAwareHttpClient.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("space deleted successfully");
      print("hhuhu ${response.body}");
      final data = jsonDecode(response.body);
      CustomToast.showSuccessToast(msg: "Space deleted successfully");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Homescreen(
            startIndex: 1,
            phoneNumber: Provider.of<CommonProvider>(
              listen: false,
              context,
            ).userName,
          ),
        ),
      );

      await refreshSpaces(context);
      // model?.data.removeWhere((space)=> space.id== id);
      // Space deleted successfully
      return true;
    } else {
      // Deletion failed
      print(
        'Failed to delete space: ${response.statusCode} - ${response.body}',
      );
      final data = jsonDecode(response.body);
      CustomToast.showErrorToast(msg: "${data['message']}");
      return false;
    }
  }

  Future<bool> deleteSetup(String setupId, BuildContext context) async {
    final url = Uri.parse('$baseUrl/spaces/$selectedSpaceId/setups/$setupId');
    final token = Provider.of<CommonProvider>(
      context,
      listen: false,
    ).accessToken;

    final response = await TokenAwareHttpClient.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Setup deleted successfully");
      print("Response body: ${response.body}");

      try {
        final data = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
      } catch (e) {
        print("Error decoding response body: $e");
      }

      CustomToast.showSuccessToast(msg: "Setup deleted successfully");

      // Give the toast time to display (adjust duration if needed)
      Future.delayed(const Duration(milliseconds: 800), () {
        fetchSetupDevices(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homescreen(
              startIndex: 1,
              phoneNumber: Provider.of<CommonProvider>(
                context,
                listen: false,
              ).selectedSpaceName,
            ),
          ),
        );
      });

      return true;
    } else {
      print(
        'Failed to delete setup: ${response.statusCode} - ${response.body}',
      );
      try {
        final data = jsonDecode(response.body);
        CustomToast.showErrorToast(msg: "${data['message']}");
      } catch (e) {
        CustomToast.showErrorToast(msg: "An unexpected error occurred.");
      }
      return false;
    }
  }

  /// delete the setup
  Future<bool> deleteDevice(String deviceId, BuildContext context) async {
    final url = Uri.parse('$baseUrl/spaces/$selectedSpaceId/devices/$deviceId');
    final token = Provider.of<CommonProvider>(
      listen: false,
      context,
    ).accessToken;

    final response = await TokenAwareHttpClient.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("device deleted successfully");
      print("hhuhu ${response.body}");
      CustomToast.showSuccessToast(msg: "Device deleted successfully");

      await Future.delayed(Duration(milliseconds: 1500));

      // Check if context is still valid (widget is mounted)
      if (Navigator.canPop(context) || context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homescreen(
              startIndex: 1,
              phoneNumber: Provider.of<CommonProvider>(
                listen: false,
                context,
              ).selectedSpaceName,
            ),
          ),
        );
      }

      // await refreshSpaces(context);
      // model?.data.removeWhere((space)=> space.id== id);
      // Space deleted successfully
      return true;
    } else {
      // Deletion failed
      print(
        'Failed to delete space: ${response.statusCode} - ${response.body}',
      );
      final data = jsonDecode(response.body);
      CustomToast.showErrorToast(msg: "${data['message']}");
      return false;
    }
  }

  // Future<void> refreshSetup(BuildContext context) async {
  //   final model = await fetchSetupDevices(context);
  //   if (model != null) {
  //     _setupDevices = model.data.cast<GetAllSetupDevicesModel>();
  //     notifyListeners();
  //   }
  // }

  Future<void> setupDeviceTankAutomationMultiple({
    required int minLevel,
    required int maxLevel,
    required String conditionDeviceId,
    required String conditionDeviceType,
    required String slotType,
    required List<Map<String, dynamic>> actions,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/spaces/$selectedSpaceId/setups');
      final token = Provider.of<CommonProvider>(
        context,
        listen: false,
      ).accessToken;

      final validActions = actions
          .where(
            (a) =>
                (a['device_id']?.toString().isNotEmpty ?? false) &&
                (a['set_status']?.toString().isNotEmpty ?? false) &&
                (a['switch_no']?.toString().isNotEmpty ?? false),
          )
          .map(
            (a) => {
              "device_id": a['device_id'],
              "set_status": a['set_status'],
              "switch_no": a['switch_no'],
              "delay": a['delay'] ?? 0,
            },
          )
          .toList();
       final body = {
        "name": "Motor Automation",
        "description": "Turn on blockB when block is off",
        "condition": {
          "device_id": conditionDeviceId,
          "device_type": conditionDeviceType,
          "level": 0,
          "operator": "<=",
          "trigger": minLevel,
          "stop": maxLevel,
          "slot" : slotType,
          "actions": validActions, // ✅ moved inside "condition"
        },
        "active": true,
      };

      print("Sending automation tank setup (multi): ${jsonEncode(body)}");

      final response = await TokenAwareHttpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
        context: context,
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          data['success'] == true) {
        CustomToast.showSuccessToast(msg: "${data['message']}");
        fetchSetupDevices(context);
      } else {
        CustomToast.showErrorToast(msg: "${data['message']}");
        throw Exception('Failed to set up tank automation');
      }
    } catch (e) {
      print("Exception in setupDeviceTankAutomationMultiple: $e");
      CustomToast.showErrorToast(msg: "$e");
      rethrow;
    }
  }

  /// Setup base automation with multiple actions
  Future<void> setupDeviceBaseAutomationMultiple({
    required String conditionStatus,
    required String conditionDeviceId,
    required String conditionDeviceType,
    required String conditionSwitchNo,
    required List<Map<String, String>> actions,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/spaces/$selectedSpaceId/setups');
      final token = Provider.of<CommonProvider>(
        listen: false,
        context,
      ).accessToken;

      final body = {
        "name": "Motor Automation",
        "description": "Turn on blockB when block is off",
        "condition": {
          "device_id": conditionDeviceId,
          "device_type": conditionDeviceType,
          "switch_no": conditionSwitchNo,
          "status": conditionStatus,
          "actions": actions
              .where(
                (a) =>
                    (a['device_id']?.isNotEmpty ?? false) &&
                    (a['set_status']?.isNotEmpty ?? false) &&
                    (a['switch_no']?.isNotEmpty ?? false),
              )
              .map(
                (a) => {
                  "device_id": a['device_id'],
                  "set_status": a['set_status'],
                  "switch_no": a['switch_no'],
                  "delay": 0,
                },
              )
              .toList(),
        },
        "active": true,
      };

      print("🚀 Final API body: ${jsonEncode(body)}");

      final response = await TokenAwareHttpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
        context: context,
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccessToast(msg: "${data['message']}");
        fetchSetupDevices(context);
      } else {
        CustomToast.showErrorToast(msg: "${data['message']}");
        throw Exception('Failed to set up base automation');
      }
    } catch (e) {
      print("Exception in setupDeviceBaseAutomationMultiple: $e");
      CustomToast.showErrorToast(msg: "$e");
      rethrow;
    }
  }

  GetAllSetupDevicesModel? _setupDevices;

  GetAllSetupDevicesModel? get setupDevices => _setupDevices;

  /// get all setup with space id
  Future<void> fetchSetupDevices(BuildContext context) async {
    final url = Uri.parse(
      '$baseUrl/spaces/$selectedSpaceId/setups',
    );
    final token = Provider.of<CommonProvider>(
      context,
      listen: false,
    ).accessToken;

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await TokenAwareHttpClient.get(
        url,
        headers: headers,
        context: context,
      );
      if (response.statusCode == 200) {
        _setupDevices = getAllSetupDevicesModelFromJson(response.body);
        print(" setup devices $_setupDevices");
        notifyListeners();
      } else {
        print('Failed to fetch setup: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching setup: $e');
      return;
    }
  }

  TankSensorsModel? _tankSensorsModel;

  TankSensorsModel? get tankSensorsModel => _tankSensorsModel;
  TankDatum? getSensorData(String deviceId, String slaveName) {
    String key = _tankKey(deviceId, slaveName);
    return _tankSensorMap[key]?.data?.first;
  }

  Map<String, TankSensorsModel> _tankSensorMap = {};
  Map<String, TankSensorsModel> get tankSensorMap => _tankSensorMap;
  String _tankKey(String deviceId, String slaveName) => '$deviceId-$slaveName';

  Future<void> tankSensors(
    BuildContext context,
    String deviceId,
    String slaveName,
  ) async {
    final url = Uri.parse('$baseUrl/tank-data/latest/$deviceId/$slaveName');
    final token = Provider.of<CommonProvider>(
      context,
      listen: false,
    ).accessToken;

    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await TokenAwareHttpClient.get(
        url,
        headers: headers,
        context: context,
      );
      print(
        'Requesting tank data from: $baseUrl/tank-data/latest/$deviceId/$slaveName',
      );

      print('➡️ Request URL: $url');
      print('➡️ Headers: $headers');

      if (deviceId.isEmpty || slaveName.isEmpty) {
        print('❌ Invalid input: deviceId="$deviceId", slaveName="$slaveName"');
        return;
      }
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final model = tankSensorsModelFromJson(response.body);
        _tankSensorMap[_tankKey(deviceId, slaveName)] = model;
        print(
          "Stored tank sensor for $deviceId/$slaveName: ${model.data?.first.value}",
        );
        notifyListeners();
      } else {
        print('Failed to fetch tank sensors: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Response headers: ${response.headers}');
      }
    } catch (e) {
      print('Error fetching tank sensors: $e');
    }
  }

  BaseSensorsModel? _baseSensorsModel;

  BaseSensorsModel? get baseSensorsModel => _baseSensorsModel;

  Map<String, Datum> _deviceSensorData = {};

  Map<String, Datum> get deviceSensorData => _deviceSensorData;

  Future<void> baseSensors(
    BuildContext context,
    String deviceId,
    String switchNo,
  ) async {
    print('Fetching base sensor for $deviceId/$switchNo');

    final token = Provider.of<CommonProvider>(
      context,
      listen: false,
    ).accessToken;
    final url = Uri.parse('$baseUrl/status/$deviceId/$switchNo');
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await TokenAwareHttpClient.get(
        url,
        headers: headers,
        context: context,
      );
      print('Response code for $deviceId/$switchNo: ${response.statusCode}');

      if (response.statusCode == 200) {
        final model = baseSensorsModelFromJson(response.body);
        if (model.data != null && model.data!.isNotEmpty) {
          final key = '$deviceId-$switchNo';
          _deviceSensorData[key] = model.data!.first;

          notifyListeners();
        }
      } else {
        print('Failed to fetch base sensors: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching base sensors: $e');
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<void> initializeDefaultSpace(BuildContext context) async {
    var accessToken = Provider.of<CommonProvider>(
      context,
      listen: false,
    ).accessToken;
    // Wait until accessToken is available
    int retry = 0;
    while ((accessToken == null || accessToken!.isEmpty) && retry < 5) {
      debugPrint("🔁 Waiting for access token...");
      await Future.delayed(const Duration(milliseconds: 300));
      accessToken =
          (await getAccessToken())!; // Optional if you lazy load token
      retry++;
    }

    if (accessToken == null || accessToken!.isEmpty) {
      debugPrint("⛔ Token still empty. Cannot initialize default space.");
      return;
    }

    final spacesModel = await fetchSpaces(context);

    if (spacesModel != null && spacesModel.data.isNotEmpty) {
      final defaultSpace = spacesModel.data[0];

      setSelectedSpaceAndDevice(defaultSpace.id);

      Provider.of<CommonProvider>(
        context,
        listen: false,
      ).setSelectedSpaceName(defaultSpace.spaceName);

      // Optional: await or chain if needed
      await getDevicesBySpaceId(context);
      await fetchSetupDevices(context);
    } else {
      debugPrint("⛔ No spaces found during initialization.");
    }
  }

  Future<bool> ensureTokenReady(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      print("🔁 Access token is missing. Trying to refresh...");
      final refreshed = await Provider.of<CommonProvider>(
        context,
        listen: false,
      ).refreshAccessToken(context);
      return refreshed;
    }

    return true;
  }

  final Guid serviceUuid = Guid("7fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Guid characteristicUuid = Guid("7eb5483e-36e1-4688-b7f5-ea07361b26a8");

  Future<void> connectAndSendWiFiCreds({
    required BluetoothDevice device,
    required String ssid,
    required String password,
    required VoidCallback onSuccess,
    required BuildContext context,
  }) async {
    try {
      debugPrint("⏳ Connecting to ${device.name}...");

      await device.connect(
        autoConnect: false,
        timeout: const Duration(seconds: 15),
      );
      debugPrint("✅ Connected to ${device.name}");

      List<BluetoothService> services = await device.discoverServices();

      for (BluetoothService service in services) {
        if (service.uuid == serviceUuid) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            final response = await characteristic.read();

            final jsonStr = utf8.decode(
              response.takeWhile((b) => b != 0).toList(),
            );
            debugPrint("📥 Received response: $jsonStr");

            final jsonMap = json.decode(jsonStr);
            final deviceId = jsonMap['deviceid'] ?? 'UNKNOWN_DEVICE';

            if (characteristic.uuid == characteristicUuid) {
              final payload = {
                "deviceid": deviceId,
                "ssid": ssid,
                "password": password,
                "mode": 1,
              };

              final bytes = utf8.encode(json.encode(payload));
              await characteristic.write(bytes, withoutResponse: false);
              debugPrint("📤 Sent Wi-Fi credentials to device $payload");

              onSuccess();

              // 🔁 Start polling for device registration
              bool? isResponded;
              const maxRetries = 5;
              int attempts = 0;

              // while (attempts < maxRetries) {
              //   await Future.delayed(
              //     const Duration(seconds: 2),b 
              //   ); // wait before retry
              //   isResponded = await checkIsRespondedBase(
              //     deviceId: deviceId,
              //     context: context,
              //   );

              //   if (isResponded == true) {
              //     debugPrint("✅ Device has responded from base");
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text(
              //           "Device successfully connected to Wi-Fi and registered.",
              //         ),
              //       ),
              //     );
              //     break;
              //   }

              //   attempts++;
              // }

              // if (isResponded != true) {
              //   debugPrint("❌ Device did not respond in time");
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text("Device did not respond in time."),
              //     ),
              //   );
              // }

              return;
            }
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bluetooth characteristic not found")),
      );
    } catch (e) {
      debugPrint("⚠️ Error sending Wi-Fi credentials: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      try {
        await device.disconnect();
      } catch (_) {}
    }
  }

   Future<void> connectAndSendWithoutWiFiCreds({
  required String deviceId,
  required String slaveId,
  required String deviceNameTank,
  required String switchNo,
  required String sensorNo,
  required int range,
  required int capacity,
  required BluetoothDevice device,
  required BuildContext context,
  required VoidCallback onSuccess,
}) async {
  final url = Uri.parse('$baseUrl/slave-request');
  final token = Provider.of<CommonProvider>(context, listen: false).accessToken;

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  // 🚀 Only send these fields to API
  final payload = {
    "deviceid": deviceId,
    "slaveid": slaveId,
    "sensor_no": sensorNo,
    "value": "",
  };

  debugPrint('🌐 Sending POST to $url');
  debugPrint('Payload: ${jsonEncode(payload)}');

  try {
    final response = await TokenAwareHttpClient.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
      context: context,
    );

    if (response.statusCode == 200) {
      debugPrint("✅ API request successful: ${response.body}");

      final responseData = jsonDecode(response.body);
      final data = responseData['data'];

      if (data != null) {
        // 📦 Construct clean BLE data (with range & capacity)
        final transformed = {
          "deviceid": data['slaveid'] ?? "",
          "mode": 3,
          "channel": data['channel'] ?? 0,
          "addl": data['addl'] ?? 0,
          "addh": data['addh'] ?? 0,
          "sensor_no": data['sensor_no'] ?? "",
          "range": range,
          "capacity": capacity,
        };

        final transformedStr = jsonEncode(transformed);
        final bytes = utf8.encode(transformedStr);

        debugPrint("📦 Final BLE Payload: $transformedStr");
        debugPrint("BLE Payload Length: ${bytes.length}");

        // 🔗 Connect to BLE device
        try {
          if (device.state != BluetoothDeviceState.connected) {
            await device.connect(autoConnect: false, timeout: const Duration(seconds: 15));
            debugPrint("✅ Connected to ${device.name}");
          } else {
            debugPrint("🔗 Already connected to ${device.name}");
          }

          // Discover target service & characteristic
          List<BluetoothService> services = await device.discoverServices();
          BluetoothCharacteristic? targetCharacteristic;

          for (BluetoothService service in services) {
            if (service.uuid == serviceUuid) {
              for (BluetoothCharacteristic characteristic in service.characteristics) {
                if (characteristic.uuid == characteristicUuid) {
                  targetCharacteristic = characteristic;
                  break;
                }
              }
            }
          }

          if (targetCharacteristic == null) {
            throw Exception("❌ Target characteristic not found!");
          }

          // ✉️ Send JSON data to BLE device
          await targetCharacteristic.write(bytes, withoutResponse: false);
          debugPrint("📤 Sent to BLE device successfully");

        } catch (e) {
          debugPrint("⚠️ BLE Error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("BLE Error: $e")),
          );
        } finally {
          // Ensure disconnection
          try {
            await device.disconnect();
            debugPrint("🔚 Disconnected from ${device.name}");
          } catch (_) {}
        }

        // 💾 Register device after BLE send
        await addDeviceWithoutWifiTank(
          switchNo: switchNo,
          context: context,
          deviceName: deviceNameTank,
          deviceId: slaveId,
          baseDeviceId: deviceId,
          transformedData: transformed,
          range: range,
          capacity: capacity,
          onSuccess: () {
            debugPrint("✅ Device registered successfully!");
          },
        );

        // 💧 Fetch tank data
        try {
          final tankData = await fetchLatestTankData(
            deviceId: deviceId,
            tankId: "TM1",
            context: context,
          );
          debugPrint("💧 Latest Tank Data: ${jsonEncode(tankData)}");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tank data fetched successfully!")),
          );
        } catch (e) {
          debugPrint("⚠️ Error fetching tank data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching tank data: $e")),
          );
        }

        onSuccess();
      } else {
        throw Exception("Invalid response: 'data' is null");
      }
    } else {
      final message = jsonDecode(response.body)['message'] ?? "Unknown error";
      debugPrint("❌ API Request failed: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $message")),
      );
    }
  } catch (e) {
    debugPrint("⚠️ Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}


// Future<void> connectAndSendWithoutWiFiCreds({
//   required String deviceId,
//   required String slaveId,
//   required String deviceNameTank,
//   required String switchNo,
//   required int range,
//   required int capacity,
//   required BluetoothDevice device,
//   required BuildContext context,
//   required VoidCallback onSuccess,
// }) async {
//   try {
//     debugPrint("🚀 Starting local tank setup without Wi-Fi...");

//     // ✅ 1. Define payload (what you want to send via Bluetooth)
//     final payload = {
//       "deviceid": slaveId,
//       // "slaveid": slaveId,
//       "sensor_no": "TM1",
//       "mode": 3,
//       "channel": 23,
//       "addl": "0x02",
//       "addh": "0x00",
//       "range": range,
//       "capacity": capacity
//     };

//     final payloadStr = jsonEncode(payload);
//     final bytes = utf8.encode(payloadStr);
//     debugPrint("📦 Payload to send via Bluetooth: $payloadStr");

//     // ✅ 2. Connect to the Bluetooth device
//     await device.connect(autoConnect: false, timeout: const Duration(seconds: 15));
//     debugPrint("✅ Connected to Bluetooth device: ${device.name}");

//     // ✅ 3. Discover services and characteristics
//     List<BluetoothService> services = await device.discoverServices();
//     BluetoothCharacteristic? targetCharacteristic;

//     for (BluetoothService service in services) {
//       if (service.uuid == serviceUuid) {
//         for (BluetoothCharacteristic characteristic in service.characteristics) {
//           if (characteristic.uuid == characteristicUuid) {
//             targetCharacteristic = characteristic;
//             break;
//           }
//         }
//       }
//     }

//     if (targetCharacteristic == null) {
//       throw Exception("❌ Target Bluetooth characteristic not found!");
//     }

//     // ✅ 4. Send payload to Bluetooth characteristic
//     await targetCharacteristic.write(bytes, withoutResponse: false);
//     debugPrint("📤 Sent payload to device successfully!");

//     // ✅ 5. Prepare data for backend registration
//    final transformedData = {
//   "sensor_no": "TM1",
//   "channel": "23",
//   "addl": "0x02",
//   "addh": "0x00",
// };
//     // ✅ 6. Register device on backend
//     await addDeviceWithoutWifiTank(
//       context: context,
//       deviceName: deviceNameTank,
//       deviceId: slaveId,
//       baseDeviceId: deviceId,
//       switchNo: switchNo,
//       transformedData: transformedData,
//       range: range,
//       capacity: capacity,
//       onSuccess: () {
//         debugPrint("✅ Device added successfully to backend!");
//       },
//     );

//     // ✅ 7. Notify UI success
//     onSuccess();
//   } catch (e) {
//     debugPrint("⚠️ Error in connectAndSendWithoutWiFiCreds: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error: ${e.toString()}")),
//     );
//   } finally {
//     // ✅ 8. Always disconnect Bluetooth to avoid lock
//     try {
//       await device.disconnect();
//       debugPrint("🔌 Disconnected from device.");
//     } catch (_) {
//       debugPrint("⚠️ Could not disconnect device (might already be disconnected).");
//     }
//   }
// }



  // Function to register the device after successful data transmission
  Future<void> addDeviceWithoutWifiTank({
  required BuildContext context,
  required VoidCallback onSuccess,
  required String deviceId,
  required String deviceName,
  required String baseDeviceId,
  required String switchNo,
  required int range,
  required int capacity,
  required Map<String, dynamic> transformedData,
}) async {
  final url = Uri.parse(
    '$baseUrl/spaces/$selectedSpaceId/devices/$baseDeviceId/switch/$switchNo/tank',
  );

  final token = Provider.of<CommonProvider>(
    context,
    listen: false,
  ).accessToken;

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  // ✅ Build the JSON body using the transformed data
  final body = jsonEncode({
    "device_id": deviceId,
    "device_name": deviceName,
    "connection_type": "without_wifi",
    "slave_name": transformedData["sensor_no"] ?? "TM1",
    "channel": transformedData["channel"] ?? "23",
    "addl": transformedData["addl"] ?? "0x02",
    "addh": transformedData["addh"] ?? "0x00",
    "range": range,
    "capacity": capacity,
  });

  debugPrint("📡 Sending device registration to: $url");
  debugPrint("📦 Body: $body");

  setAddDeviceWithoutLoading(true);

  try {
    final response = await TokenAwareHttpClient.post(
      url,
      headers: headers,
      body: body,
      context: context,
    );

    setAddDeviceWithoutLoading(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final success = data['success'] ?? false;
      final message = data['message'] ?? "No message";

      if (success) {
        debugPrint('✅ Device added successfully: ${response.body}');
        CustomToast.showSuccessToast(msg: message);
        onSuccess();
      } else {
        debugPrint("⚠️ Server responded with failure: $message");
        CustomToast.showErrorToast(msg: message);
      }
    } else {
      final decoded = jsonDecode(response.body);
      final message = decoded['message'] ?? "Unexpected error occurred";
      debugPrint("❌ Server error ${response.statusCode}: $message");
      CustomToast.showErrorToast(msg: message);
    }
  } catch (e) {
    setAddDeviceWithoutLoading(false);
    debugPrint("⚠️ Exception while adding device: $e");
    CustomToast.showErrorToast(msg: "Error: $e");
  }
}

   Future<Map<String, dynamic>> fetchLatestTankData({
    required String deviceId,
    required String tankId,
  required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/tank-data/latest/$deviceId/$tankId');

    try {
      final response = await TokenAwareHttpClient.get(  url,
        context: context,
        headers: {
          // 'Authorization': 'Bearer YOUR_TOKEN',
          'Content-Type': 'application/json',
        },);

      if (response.statusCode == 200) {
        // Assuming the API returns JSON
        final Map<String, dynamic> data = json.decode(response.body);
        print("tank data $data");
        return data;
      } else {
        throw Exception('Failed to fetch data. Status: ${response.statusCode}');
      }
    } catch (e) {
      // You can add more nuanced error handling here
      throw Exception('Error fetching tank data: $e');
    }
  }


  //// after device gets connected then we have to get the devices in base
  Future<bool?> checkIsRespondedBase({
    required String deviceId,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/$deviceId/isResponded');

      final response = await TokenAwareHttpClient.get(
        url,
        context: context,
        headers: {
          // 'Authorization': 'Bearer YOUR_TOKEN',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Response JSON: $jsonResponse");

        // Assuming response is like: { "isResponded": true }
        return jsonResponse['isResponded'];
      } else {
        print("Failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during GET: $e");
      return null;
    }
  }

  //// after device gets connected then we have to get the devices in tank
  Future<bool?> checkIsRespondedTank({
    required String deviceId,
    required String switchNumber,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/$deviceId/$switchNumber/isResponded');

      final response = await TokenAwareHttpClient.get(
        url,
        context: context,
        headers: {
          // 'Authorization': 'Bearer YOUR_TOKEN',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Response JSON: $jsonResponse");

        // Assuming response is like: { "isResponded": true }
        return jsonResponse['isResponded'];
      } else {
        print("Failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during GET: $e");
      return null;
    }
  }
}
