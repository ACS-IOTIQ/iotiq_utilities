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

class SearchingTankScreen extends StatefulWidget {
  SearchingTankScreen({
    super.key,
    required this.itemName,
    required this.imageUrl,
  });

  late String itemName;
  final String imageUrl;

  @override
  State<SearchingTankScreen> createState() => _SearchingTankScreenState();
}

class _SearchingTankScreenState extends State<SearchingTankScreen> {
  List<ScanResult> _scanResults = [];
  bool isScanning = false;
  Map<String, String> deviceIdMap = {};

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
              if (name.toLowerCase().contains('IOTIQ')) {
                widget.itemName = 'base';
              } else if (name.toLowerCase().contains('IOTIQTM')) {
                widget.itemName = 'tank';
              }
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
    try {
      debugPrint("⏳ Connecting to ${device.name}...");

      if (device.state != BluetoothDeviceState.connected) {
        await device.connect(
          autoConnect: false,
          timeout: const Duration(seconds: 15),
        );
      }

      debugPrint("✅ Connected to ${device.name}");

      // // Dummy navigation for now
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DeviceWifisetup(
      //       itemName: widget.itemName,
      //       imageUrl: widget.imageUrl,
      //       deviceId: deviceIdMap[device.id.id] ?? 'UNKNOWN',
      //       thingId: "thing_dummy_id",
      //       device: ,
      //     ),
      //   ),
      // );
    } catch (e) {
      debugPrint("⚠️ Connection error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: ${e.toString()}")),
      );
    } finally {
      try {
        await device.disconnect();
      } catch (_) {}
    }
  }

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
                    Text('No IOTIQ devices found', style: w400_14Poppins()),
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
