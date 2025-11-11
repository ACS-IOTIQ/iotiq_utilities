import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/devices/device_added.dart';
import 'package:utility/ui/devices/tankDeviceCapacity.dart';
import 'package:utility/utils/custom_bottomsheet.dart';

import 'package:utility/utils/images.dart';
import 'package:utility/utils/app_fonts.dart';

class DeviceWifisetup extends StatefulWidget {
  const DeviceWifisetup({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.deviceId,
    required this.thingId,
    required this.device,
    required this.sensorNo
  });
  final String itemName;
  final String imageUrl;
  final String deviceId;
  final String sensorNo;
  final String thingId;
  final BluetoothDevice device;

  @override
  State<DeviceWifisetup> createState() => _DeviceWifisetupState();
}

class _DeviceWifisetupState extends State<DeviceWifisetup> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController wifiNameContoller = TextEditingController();
  TextEditingController deviceNameBaseController = TextEditingController();
  bool _isButtonEnabled = true;
  final formKey = GlobalKey<FormState>();
  BluetoothDevice? selectedDevice;

  // Update the button state when text changes
  void _onTextChanged() {
    setState(() {
      _isButtonEnabled =
          passwordController.text.isNotEmpty; // Check if the text is not empty
    });
  }

  @override
  void dispose() {
    passwordController.removeListener(
      _onTextChanged,
    ); // Remove the listener when the widget is disposed
    passwordController.dispose();
    super.dispose();
  }

  // String _selectedName = "Select Wi-fi";
  bool _isPasswordVisible = false;
  // final List<String> _names = ["Alice", "Bob", "Charlie", "Diana", "Ethan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Consumer2<SpacesProvider, CommonProvider>(
        builder: (context, provider, commonProvider, child) {
          return Column(
            children: [
              Visibility(
                visible: widget.itemName == "Base",
                child: Expanded(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                              controller: deviceNameBaseController,
                              keyboardType: TextInputType.name,
                              style: w400_14Poppins(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Enter device name',
                    
                                hintStyle: w400_14Poppins(
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none, // No border
                                filled: true,
                                fillColor: Colors.white,
                                // Background color
                              ),
                            ),
                          ),
                          height10,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedBackgroundColor: const Color(
                                  0xffF6F2E8,
                                ),
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
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
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
                                              border:
                                                  InputBorder.none, // No border
                                              filled: true,
                                              fillColor: Colors.white,
                                              // Background color
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter SSID';
                                              }
                                              return null;
                                            },
                                          ),
                    
                                          const Divider(color: Colors.black12),
                                          TextFormField(
                                            controller: passwordController,
                                            obscureText: !_isPasswordVisible,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            style: w400_14Poppins(
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Enter Password*',
                                              hintStyle: w400_14Poppins(
                                                color: Colors.grey.shade500,
                                              ),
                                              border: InputBorder.none,
                                              filled: true,
                                              fillColor: Colors.white,
                    
                                              // 👁️ Toggle password visibility icon
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              height: 35.h,
                              width: 320.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    provider.connectAndSendWiFiCreds(
                                      ssid: wifiNameContoller.text,
                                      password: passwordController.text,
                                      context: context,
                                      device: widget.device,
                                      onSuccess: () {},
                                    );
                    
                                    provider.addDeviceWithWifiBase(
                                      context: context,
                                      deviceId: widget.deviceId,
                                      deviceName: deviceNameBaseController.text,
                                      deviceType: widget.itemName.toLowerCase(),
                                      ssid: wifiNameContoller.text,
                                      password: passwordController.text,
                                      thingId: widget.thingId,
                                      onSuccess: () {
                                        customShowDialog(
                                          context,
                                          connectWifiBottomSheet(context),
                                          backGroundColor: const Color(
                                            0xffFBFAF5,
                                          ),
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
                                  }
                                },
                                // Button is disabled when _isButtonEnabled is false
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isButtonEnabled
                                      ? const Color(0xffC39C67)
                                      : const Color(
                                          0xffE7E9E8,
                                        ), // Button color changes based on state
                                  // onSurface: Colors.grey, // Color for disabled state (onPressed is null)
                                ),
                                child: Text(
                                  'Connect to Wi-fi',
                                  style: w500_14Poppins(
                                    color: _isButtonEnabled
                                        ? Colors.white
                                        : const Color.fromARGB(255, 20, 28, 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.itemName == "Tank",
                child: TankDeviceCapacityScreen(
                  sensorNo: widget.sensorNo,
                  device: widget.device,
                  itemName: widget.itemName,
                  imageUrl: widget.imageUrl,
                  deviceId: widget.deviceId,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  connectWifiBottomSheet(BuildContext context) {
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
            "Connecting IOTIQ ${widget.itemName} Module to ${wifiNameContoller.text} Wifi 5g",
            style: w400_14Poppins(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
