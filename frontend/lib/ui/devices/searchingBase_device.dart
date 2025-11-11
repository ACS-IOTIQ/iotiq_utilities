import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/ui/devices/device_wifiSetup.dart';

class SearchingbaseScreen extends StatefulWidget {
  SearchingbaseScreen({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.sensroNo,
  });

  late String itemName;
final String sensroNo;
  final String imageUrl;

  @override
  State<SearchingbaseScreen> createState() => _SearchingbaseScreenState();
}

class _SearchingbaseScreenState extends State<SearchingbaseScreen> {
  final Guid serviceUuid = Guid("7fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Guid characteristicUuid = Guid("7eb5483e-36e1-4688-b7f5-ea07361b26a8");

  List<ScanResult> _scanResults = [];
  bool isScanning = false;
  Map<String, String> deviceIdMap = {}; // key = BluetoothDevice.id.id

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    bool granted = await _requestPermissions();

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth permissions are required')),
      );
      return;
    }

    var bluetoothState = await FlutterBluePlus.state.first;
    if (bluetoothState == BluetoothState.off) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Bluetooth is Off"),
          content: const Text("Please turn on Bluetooth to continue."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    _startScan();
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> _startScan() async {
    setState(() {
      isScanning = true;
      _scanResults.clear();
      deviceIdMap.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          final device = result.device;
          final name = device.name.trim();

          if (name.toUpperCase().startsWith("IOTIQ")) {
            if (!_scanResults.any((r) => r.device.id == device.id)) {
              // final nameLower = name.toLowerCase();

              // bool isBase =
              //     nameLower.contains("iotiq") && !nameLower.contains("iotiqtm");
              // bool isTank = nameLower.contains("iotiqtm");

              // if ((widget.itemName == 'Base' && isBase) ||
              //     (widget.itemName == 'Tank' && isTank)) {
              //   if (!_scanResults.any((r) => r.device.id == device.id)) {
              //     setState(() {
              //       _scanResults.add(result);
              //       deviceIdMap[device.id.id] = name;
              //     });

              //     debugPrint(
              //       "📡 Found ${widget.itemName} device: ${device.name}",
              //     );
              //   }
              // }

              setState(() {
                _scanResults.add(result);
                deviceIdMap[device.id.id] = name;
              });

              debugPrint("📡 Found IOTIQ device: ${device.name}");
            }
          }
        }
      });
    } catch (e) {
      debugPrint("Scan error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Scan error: ${e.toString()}")));
    } finally {
      await Future.delayed(const Duration(seconds: 15));
      await FlutterBluePlus.stopScan();
      setState(() {
        isScanning = false;
      });
    }
  }
Future<void> connectAndRead(BluetoothDevice device) async {
  final maxAttempts = 2;
  int attempt = 0;
  bool connected = false;
  bool success = false;               // NEW
  StreamSubscription<List<int>>? sub; // keep handle
 
  while (attempt < maxAttempts && !success) {
    try {
      attempt++;
      final currentState = await device.state.first;
      if (currentState != BluetoothDeviceState.connected) {
        await device.connect(autoConnect: false, timeout: const Duration(seconds: 30));
        connected = true;
      } else {
        connected = true;
      }
 
      // Discover + find your exact service/characteristic
      final services = await device.discoverServices();
      BluetoothCharacteristic? ch;
      for (final s in services) {
        if (s.uuid == serviceUuid) {
          for (final c in s.characteristics) {
            if (c.uuid == characteristicUuid) { ch = c; break; }
          }
        }
        if (ch != null) break;
      }
      if (ch == null) throw Exception("JSON characteristic not found");
 
      // Subscribe FIRST
      await ch.setNotifyValue(true);
 
      // Wait for FIRST valid JSON frame (or timeout)
      final completer = Completer<Map<String, dynamic>>();
      sub = ch.value.listen((value) {
        try {
          final jsonStr = utf8.decode(value.takeWhile((b) => b != 0).toList());
          final obj = json.decode(jsonStr);
          if (obj is Map && obj['deviceid'] != null && obj['thingId'] != null) {
            if (!completer.isCompleted) completer.complete(Map<String, dynamic>.from(obj));
          }
        } catch (_) {}
      });
 
      // Kick a READ as a fallback while notifications settle
      try {
        final rv = await ch.read();
        final js = utf8.decode(rv.takeWhile((b) => b != 0).toList());
        final obj = json.decode(js);
        if (obj is Map && obj['deviceid'] != null && obj['thingId'] != null) {
          if (!completer.isCompleted) completer.complete(Map<String, dynamic>.from(obj));
        }
      } catch (_) {}
 
      final data = await completer.future.timeout(const Duration(seconds: 8)); // wait up to 8s
      final deviceId = data['deviceid'] as String;
      final thingId  = data['thingId']  as String;
 
      deviceIdMap[device.id.id] = deviceId;
 
      // Navigate — keep the connection alive or disconnect explicitly AFTER navigation if you want
      success = true;
      await sub.cancel();  // optional: stop listening now
      // If you want to keep the BLE link for the next screen, DO NOT disconnect here.
      // If you want to close it now:
      // await device.disconnect();
 
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceWifisetup(
              device: device,
              sensorNo: widget.sensroNo,
              itemName: widget.itemName,
              imageUrl: widget.imageUrl,
              deviceId: deviceId,
              thingId: thingId,
            ),
          ),
        );
      }
      return;
    } catch (e) {
      if (attempt >= maxAttempts && context.mounted) {
        debugPrint("Connection failed $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection failed: $e")));
      }
    } finally {
      await sub?.cancel();
      // Only disconnect when we did NOT succeed
      if (!success) {
        try { await device.disconnect(); } catch (_) {}
      }
    }
  }
}

  /// 🔧 Custom ID Formatter
  String formatDeviceId(BluetoothDevice device) {
    String id = device.id.id.replaceAll(":", "").toUpperCase();
    String shortId = id.length >= 8 ? id.substring(id.length - 8) : id;
    return "IOTIQBM_$shortId";
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Searching for ${widget.itemName} Module",
              style: w400_14Poppins(),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bluetooth_searching,
                  size: 16,
                  color: Colors.black38,
                ),
                SizedBox(width: 5.w),
                Text(
                  "Nearby Devices",
                  style: w400_10Poppins(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isScanning
            ? const Center(
                child: CircularProgressIndicator(color: Appcolors.appColor),
              )
            : _scanResults.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No matching devices found', style: w400_14Poppins()),
                    SizedBox(height: 15.h),
                    CustomButton(
                      buttonColor: Appcolors.appColor,
                      buttonText: "Home",
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Homescreen(
                              startIndex: 1,
                              phoneNumber: Provider.of<CommonProvider>(
                                context,
                                listen: false,
                              ).userName,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _scanResults.length,
                itemBuilder: (context, index) {
                  final result = _scanResults[index];
                  final device = result.device;
                  final deviceIdText =
                      deviceIdMap[device.id.id] ?? formatDeviceId(device);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.w,
                          height: 86.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Image.asset(widget.imageUrl),
                        ),
                        SizedBox(width: 15.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.name.isNotEmpty
                                  ? "${widget.itemName} Module"
                                  : "Unnamed Device",
                              style: w500_14Poppins(),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              deviceIdText,
                              style: w400_11Poppins(
                                color: const Color(0xff11271D),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomButton(
                              onTap: () => connectAndRead(device),
                              width: 110.w,
                              height: 25.h,
                              buttonColor: const Color(0xffC39C67),
                              buttonText: "Setup Device",
                              borderRadius: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ); 
                },
              ),
      ),
    );
  }
}
  