import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/devices/device_added.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_bottomsheet.dart';
import 'package:utility/utils/images.dart';

class DeviceWifisetuptank extends StatefulWidget {
  const DeviceWifisetuptank({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.deviceId,
    required this.device,
    required this.capacity,
    required this.range,
    required this.sensorNo
  });
  final String itemName;
  final String imageUrl;
  final String deviceId;
  final BluetoothDevice device;
    final String sensorNo;

  final int range;
  final int capacity;

  @override
  State<DeviceWifisetuptank> createState() => _DeviceWifisetuptankState();
}

class _DeviceWifisetuptankState extends State<DeviceWifisetuptank> {
  int selectedIndex = 0;
  bool isWifiSelected = true; // default selection (you can change it)
  List<Device> baseDevices = [];

  final formKey = GlobalKey<FormState>();
bool _isPasswordVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController wifiNameContoller = TextEditingController();
  TextEditingController deviceNameTankController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Text(
              "Setup Wi-Fi",
              style: w400_14Poppins(color: const Color(0xff11271D)),
            ),
            height5,
            Text(
              "IOTIQ smart ${widget.itemName} Module",
              style: w400_10Poppins(color: const Color(0xff11271D)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer2<SpacesProvider, CommonProvider>(
            builder: (context, provider, commonProvider, child) {
              return Column(
                children: [
                  height10,
                  Container(
                    // width: 339.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: TextFormField(
                      controller: deviceNameTankController,
                      keyboardType: TextInputType.name,
                      style: w400_14Poppins(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter device name',
            
                        hintStyle: w400_14Poppins(color: Colors.grey.shade500),
                        border: InputBorder.none, // No border
                        filled: true,
                        fillColor: Colors.white,
                        // Background color
                      ),
                    ),
                  ),
                  height5,
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            onExpansionChanged: (expanded) {
                              if (expanded) {
                                setState(() {
                                  isWifiSelected = true;
                                });
                              }
                            },
                            collapsedBackgroundColor: const Color(0xffF6F2E8),
                            backgroundColor: const Color(0xffF6F2E8),
                            title: Text(
                              "Setup with Wi-Fi",
                              style: w400_16Poppins(),
                            ),
            
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 339.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: wifiNameContoller,
            
                                        keyboardType: TextInputType.name,
                                        style: w400_14Poppins(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter SSID*',
            
                                          hintStyle: w400_14Poppins(
                                            color: Colors.grey.shade500,
                                          ),
                                          border: InputBorder.none, // No border
                                          filled: true,
                                          fillColor: Colors.white,
                                          // Background color
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter SSID';
                                          }
                                          return null;
                                        },
                                      ),
            
                                      const Divider(color: Colors.black12),
                                   TextFormField(
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      style: w400_14Poppins(color: Colors.black),
      decoration: InputDecoration(
            hintText: 'Enter Password*',
            hintStyle: w400_14Poppins(color: Colors.grey.shade500),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            
            // 👁️ Toggle password visibility icon
            suffixIcon: IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
            ),
      ),
      validator: (value) {
            if (value == null || value.isEmpty) {
      return 'Please enter password';
            }
            return null;
      },
            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      height10,
                   ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
      onExpansionChanged: (expanded) {
        if (expanded) {
          setState(() {
            isWifiSelected = false;
          });
        }
      },
      collapsedBackgroundColor: const Color(0xffF6F2E8),
      backgroundColor: const Color(0xffF6F2E8),
      title: Text(
        "Setup without Wi-Fi",
        style: w400_16Poppins(),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            child: FutureBuilder<GetAllDevicesBySpaceIdModel?>(
              future: provider.getDevicesBySpaceId(context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text('No devices found'),
                  );
                }
            
                final allDevices = snapshot.data!.data.devices;
            
              final devicesList = allDevices
    .where((device) => device.deviceType.toLowerCase() == "base")
    .toList();

// ✅ Assign once if not already assigned
if (baseDevices.isEmpty) {
  baseDevices = devicesList;
}

            
                if (devicesList.isEmpty) {
                  return const Center(
                    child: Text('No base devices found'),
                  );
                }
            
                return ListView.separated(
                  itemCount: devicesList.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, _) => const Divider(
                    color: Colors.black12,
                  ),
                  itemBuilder: (context, index) {
                    final device = devicesList[index];
                    return Padding(  
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isWifiSelected = false;
                            selectedIndex = index;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                                                  "${device.deviceName} - ${device.switchNo}",
                                                                  
                              style: w400_16Poppins(),
                            ),
                            Icon(
                              selectedIndex == index
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: selectedIndex == index
                                  ? const Color(0xffC39C67)
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
            ),
      ),
            ),
            
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 35.h,
                      width: 320.w,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isWifiSelected) {
                            if (formKey.currentState?.validate() ?? false) {
                              provider.connectAndSendWiFiCreds(
                                ssid: wifiNameContoller.text,
                                password: passwordController.text,
                                context: context,
                                device: widget.device,
                                onSuccess: () {
                                  customShowDialog(
                                    context,
                                    connectWifiBottomSheet(
                                      context,
                                      wifiNameContoller.text,
                                    ),
                                    backGroundColor: const Color(0xffFBFAF5),
                                    height: 200,
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 3),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeviceAddedScreen(
                                                deviceId: widget.deviceId,
                                                itemName: widget.itemName,
                                                imageUrl: widget.imageUrl,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                              // provider.addDeviceWithoutWifiTank(
                              //   context: context,
                              //   deviceId: widget.deviceId,
                              //   onSuccess: () {
                              //     customShowDialog(
                              //       context,
                              //       connectWifiBottomSheet(
                              //         context,
                              //         wifiNameContoller.text,
                              //       ),
                              //       backGroundColor: const Color(0xffFBFAF5),
                              //       height: 200,
                              //     );
                              //     Future.delayed(
                              //       const Duration(seconds: 3),
                              //       () {
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //             builder: (context) =>
                              //                 DeviceAddedScreen(
                              //                   deviceId: widget.deviceId,
                              //                   itemName: widget.itemName,
                              //                   imageUrl: widget.imageUrl,
                              //                 ),
                              //           ),
                              //         );
                              //       },
                              //     );
                              //   },
                              // );
                            }
                          } else {
                            if (!isWifiSelected) {
                              if (selectedIndex < 0 ||
                                  selectedIndex >= baseDevices.length) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select a valid device",
                                    ),
                                  ),
                                );
                                return;
                              }
            
                              final selectedDeviceId =
                                  baseDevices[selectedIndex].deviceId;
            
                              provider.connectAndSendWithoutWiFiCreds(
                                deviceNameTank: deviceNameTankController.text,
                                sensorNo:widget.sensorNo ,
                                context: context,
                                slaveId: widget.deviceId,
                                device: widget.device,
                                deviceId: selectedDeviceId,
                                switchNo: baseDevices[selectedIndex].switchNo,
                                range: widget.range,
                                capacity: widget.capacity,
                                onSuccess: () {
                                  customShowDialog(
                                    context,
                                    connectWifiBottomSheet(
                                      context,
                                      wifiNameContoller.text,
                                    ),
                                    backGroundColor: const Color(0xffFBFAF5),
                                    height: 200,
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 3),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeviceAddedScreen(
                                                deviceId: widget.deviceId,
                                                itemName: widget.itemName,
                                                imageUrl: widget.imageUrl,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
            
                              //     provider.addDeviceWithoutWifiTank(
                              //       context: context,
                              //       deviceId: selectedDeviceId,
                              //       onSuccess: () {
                              //         customShowDialog(
                              //           context,
                              //           connectWifiBottomSheet(
                              //             context,
                              //             "Local Mode",
                              //           ),
                              //           backGroundColor: const Color(0xffFBFAF5),
                              //           height: 200,
                              //         );
                              //         Future.delayed(
                              //           const Duration(seconds: 3),
                              //           () {
                              //             Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     DeviceAddedScreen(
                              //                       deviceId: widget.deviceId,
                              //                       itemName: widget.itemName,
                              //                       imageUrl: widget.imageUrl,
                              //                     ),
                              //               ),
                              //             );
                              //           },
                              //         );
                              //       },
                              //     );
                            }
                          }
                        },
                        // Button is disabled when _isButtonEnabled is false
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffC39C67),
                        ),
                        child: Text(
                          'Connect to Wi-fi',
                          style: w500_14Poppins(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  connectWifiBottomSheet(BuildContext context, String name) {
    return Column(
      children: [
        height10,
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffEBEBEB),
            ),
          ),
        ),
        height40,
        const CircularProgressIndicator(color: Color(0xffC39C67)),
        height20,
        SizedBox(
          width: 250,
          height: 40,
          child: Text(
            "Connecting IOTIQ ${widget.itemName} Module to $name Wifi 5g",
            style: w400_14Poppins(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
