import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/ui/setup/add_tanks.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_toast.dart';
import 'package:utility/utils/images.dart';

class SelectConditionactionScreen extends StatefulWidget {
  const SelectConditionactionScreen({super.key});

  @override
  State<SelectConditionactionScreen> createState() =>
      _SelectConditionactionScreenState();
}

class _SelectConditionactionScreenState
    extends State<SelectConditionactionScreen> {
  Device? selectedConditionDevice;
  final List<bool> isSelectedCondition = [true, false];

  final List<Map<String, dynamic>> actions = [
    {
      'device': null,
      'isSelected': [true, false],
    },
  ];
  RangeValues _rangeValues = const RangeValues(
    0.3,
    0.95,
  ); // Example: 30% to 90%

  List<Device> allDevices = [];
  RangeValues _currentRangeValues = const RangeValues(30, 95);

  // bool get isFormComplete => selectedConditionDevice != null;

  String get selectedValueCondition => isSelectedCondition[0] ? "on" : "off";

  String getFirstActionStatus() {
    final firstAction = actions.first;
    return firstAction['isSelected'][0] ? "on" : "off";
  }

  String? getFirstActionId() {
    final firstAction = actions.first;
    return firstAction['device']?.deviceId;
  }

  List<Map<String, String>> get actionPayloadBase => actions
      .where((a) {
        final device = a['device'];
        final isSelected = a['isSelected'] as List<bool>?;
        return device != null &&
            device.deviceId != null &&
            device.switchNo != null &&
            device.deviceId.toString().isNotEmpty &&
            device.switchNo.toString().isNotEmpty &&
            isSelected != null &&
            isSelected.any((selected) => selected == true);
      })
      .map(
        (a) => {
          'device_id': a['device'].deviceId.toString(),
          'set_status': (a['isSelected'][0] ? "on" : "off"),
          'switch_no': a['device'].switchNo.toString(),
        },
      )
      .toList();

  List<Map<String, dynamic>> get actionPayloadTank => actions
      .where((a) {
        final device = a['device'];
        final isSelected = a['isSelected'] as List<bool>?;
        return device != null &&
            device.deviceId != null &&
            device.switchNo != null &&
            device.deviceId.toString().isNotEmpty &&
            device.switchNo.toString().isNotEmpty &&
            isSelected != null &&
            isSelected.any((selected) => selected == true);
      })
      .map(
        (a) => {
          'device_id': a['device'].deviceId.toString(),
          'set_status': (a['isSelected'][0] ? "on" : "off"),
          'switch_no': a['device'].switchNo.toString(),
          'delay': 0, // ✅ Add this
        },
      )
      .toList();

  List<String> valueSelection = ["Primary1", "Primary2","Primary3","Primary4", "Secondary"];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Setup Condition and Actions", style: w500_15Poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
        buildSlotSection(),
            height5,
            _buildConditionSection(),
            height15,
            Expanded(child: _buildActionsList()),
            const Divider(color: Color(0xffFBFAF5)),
            height10,
            _buildAddMoreActionsButton(),
            const Spacer(),
            _buildContinueButton(),
            height10,
          ],
        ),
      ),
    );
  }

  double value = 0.0;
  void _onTapDown(TapDownDetails details, BoxConstraints constraints) {
    final double tapX = details.localPosition.dx;
    final double width = constraints.maxWidth;
    final double newValue = (tapX / width).clamp(0.0, 1.0);

    setState(() {
      value = newValue;
    });
  }


  Widget buildSlotSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF5F1E5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Slot Type", style: w400_15Poppins(color: Colors.black)),
            height10,
            InkWell(
            
              child: Container(
                height: 37.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child:   DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint:  Text(
          'Select Slot Type',
          style:w400_15Poppins(),
          overflow: TextOverflow.ellipsis,
                          ),
                   items: valueSelection
                .map((type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type,
          style:w400_15Poppins(),
                      ),
                    ))
                .toList(),
                  
                       value: selectedValue,
          
          // When user selects a new item
          onChanged: (val) {
            setState(() {
              selectedValue = val;
            });
          },
                      buttonStyleData:  ButtonStyleData(
                        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.only(right: 8),
                         
                        ),
                      
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
          color: Colors.white,
          
          // border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                  ),
                ),
              ),
            ),
            height10,

          ],
        ),
      ),
    );
  }

  Widget _buildConditionSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF5F1E5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Condition", style: w400_15Poppins(color: Colors.black)),
            height10,
            InkWell(
              onTap: () {
                _showBottomSheet(
                  title: 'Select Condition Device',
                  onItemSelected: (device) {
                    setState(() {
                      selectedConditionDevice = device;
                    });
                  },
                  isForAction: false,
                );
              },
              child: Container(
                height: 37.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedConditionDevice != null
                          ? "${selectedConditionDevice?.deviceName} ${selectedConditionDevice?.switchNo}"
                          : "Select Device",
                      style: w400_15Poppins(color: Colors.black),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Appcolors.appColor,
                    ),
                  ],
                ),
              ),
            ),
            height10,

            Visibility(
              visible: selectedConditionDevice?.deviceType == "tank",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select water level condition",
                    style: w400_14Poppins(color: Colors.black),
                  ),
                  height5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width * 0.64,
                        height: 35.h,

                        child: RangeSlider(
                          values: _rangeValues,

                          // labels: RangeLabels(
                          //   (_rangeValues.start * 100).toStringAsFixed(0) + '%',
                          //   (_rangeValues.end * 100).toStringAsFixed(0) + '%',
                          // ),
                          onChanged: (RangeValues values) {
                            // Clamp to 30% (0.3) and 95% (0.95)
                            final double start = values.start < 0.3
                                ? 0.3
                                : values.start;
                            final double end = values.end > 0.95
                                ? 0.95
                                : values.end;

                            // Only update if values are within valid range
                            if (start <= end) {
                              setState(() {
                                _rangeValues = RangeValues(start, end);
                              });
                            }
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 100,

                          activeColor: Appcolors.appColor,
                        ),
                      ),

                      Container(
                        height: 35.h,
                        width: 37.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.appColor,
                        ),
                        child: Center(
                          child: Text(
                            "${(_rangeValues.start * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "-",
                          style: w500_16Poppins(color: Appcolors.appColor),
                        ),
                      ),
                      Container(
                        height: 35.h,
                        width: 37.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Appcolors.appColor,
                        ),
                        child: Center(
                          child: Text(
                            "${(_rangeValues.end * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  height10,
                ],
              ),
            ),
            Visibility(
              visible: selectedConditionDevice?.deviceType == "base",
              child: Column(
                children: [
                  Text(
                    "Select Condition Parameter",
                    style: w400_13Poppins(color: Colors.black54),
                  ),
                  height5,
                  _buildToggleButton(isSelectedCondition, (index) {
                    setState(() {
                      for (int i = 0; i < isSelectedCondition.length; i++) {
                        isSelectedCondition[i] = i == index;
                      }
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffF5F1E5),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Action", style: w400_15Poppins(color: Colors.black)),
              height10,
              InkWell( 
                onTap: () {
                  _showBottomSheet(
                    title: 'Select Action Device',
                    isForAction: true,
                    onItemSelected: (device) {
                      setState(() {
                        action['device'] = device;
                      });
                    },
                  );
                },
                child: Container(
                  height: 37.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        action['device'] != null
                            ? "${action['device']?.deviceName} ${action['device']?.switchNo}"
                            : "Select Device",
                        style: w400_14Poppins(color: Colors.black),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Appcolors.appColor,
                      ),
                    ],
                  ),
                ),
              ),
              height5,
              Text(
                "Select Action Parameter",
                style: w400_14Poppins(color: Colors.black54),
              ),
              height5,
              _buildToggleButton(action['isSelected'], (toggleIndex) {
                setState(() {
                  for (int i = 0; i < 2; i++) {
                    action['isSelected'][i] = i == toggleIndex;
                  }
                });
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(List<bool> isSelected, Function(int) onPressed) {
    return Container(
      height: 35.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(3.0),
      child: ToggleButtons(
        borderColor: Colors.transparent,
        fillColor: Appcolors.appColor,
        color: Colors.black, 
        borderRadius: BorderRadius.circular(4),
        selectedColor: Colors.black,
        isSelected: isSelected,
        onPressed: onPressed,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(child: Text("On")),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(child: Text("Off")),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreActionsButton() {
    return InkWell(
      onTap: () {
        setState(() {
          actions.add({
            'device': null,
            'isSelected': [true, false],
          });
        });
      },
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: const Color(0xffC39C67),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle, color: Colors.white),
            width10,
            Text(
              "Add more actions",
              style: w500_16Poppins(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Consumer<SpacesProvider>(
      builder: (context, spacesProvider, child) {
        return SizedBox(
          height: 35.h,
          width: 320.w,
          child: ElevatedButton(
            onPressed: () {
              if (selectedConditionDevice == null) {
                CustomToast.showErrorToast(
                  msg: "Please select a condition device.",
                );
                return;
              }
              if (actionPayloadTank.isEmpty) {
                CustomToast.showErrorToast(
                  msg: "Please add at least one valid action.",
                );
                return;
              }
              print(
                "Sending actionPayload to API: ${jsonEncode(actionPayloadTank)}",
              );
              // if (!isFormComplete) return;
              if (selectedConditionDevice?.deviceType == "tank") {
                spacesProvider.setupDeviceTankAutomationMultiple(
                  minLevel: (_rangeValues.start * 100).round(),
                  maxLevel: (_rangeValues.end * 100).round(),
                  conditionDeviceId: selectedConditionDevice!.deviceId,
                  conditionDeviceType: selectedConditionDevice!.deviceType,
                  actions: actionPayloadTank,
                  context: context,
                  slotType:selectedValue!
                );
              } else {
                spacesProvider.setupDeviceBaseAutomationMultiple(
                  conditionStatus: selectedValueCondition,
                  conditionDeviceId: selectedConditionDevice!.deviceId,
                  conditionDeviceType: selectedConditionDevice!.deviceType,
                  conditionSwitchNo: selectedConditionDevice!.switchNo,
                  actions: actionPayloadBase,
                  context: context,
                );
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homescreen(
                    startIndex: 2,
                    phoneNumber: Provider.of<CommonProvider>(
                      context,
                      listen: false,
                    ).userName,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.appColor,
            ),
            child: Text("Continue", style: w500_14Poppins(color: Colors.white)),
          ),
        );
      },
    );
  }

  Future<void> _showBottomSheet({
    required String title,
    required void Function(Device) onItemSelected,
    bool isForAction = false,
  }) async {
    final result = await showModalBottomSheet<Device>(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<SpacesProvider, CommonProvider>(
          builder: (context, spacesProvider, commonProvider, child) {
            return SizedBox(
              height: 550.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  height10,
                  Container(
                    height: 5.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffEBEBEB),
                    ),
                  ),
                  height20,
                  Text(
                    title,
                    style: w400_14Poppins(color: const Color(0xff11271D)),
                  ),
                  height20,
                  FutureBuilder<GetAllDevicesBySpaceIdModel?>(
                    future: spacesProvider.getDevicesBySpaceId(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Appcolors.appColor,
                          ),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return Center(
                          child: Text(
                            'Failed to load devices.',
                            style: w400_15Poppins(color: Colors.black),
                          ),
                        );
                      }
                      final List<Device> devices = snapshot.data!.data.devices;
                      List<Device> filteredDevices = devices;
                      if (isForAction) {
                        filteredDevices = filteredDevices
                            .where((d) => d.deviceType.toLowerCase() == "base")
                            .toList();
                        if (selectedConditionDevice != null) {
                          filteredDevices = filteredDevices
                              .where(
                                (d) =>
                                    d.deviceId !=
                                        selectedConditionDevice!.deviceId ||
                                    d.switchNo !=
                                        selectedConditionDevice!.switchNo,
                              )
                              .toList();
                        }
                      }
                      if (filteredDevices.isEmpty) {
                        return Center(
                          child: Text(
                            'No devices found.',
                            style: w400_15Poppins(color: Colors.black),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 300.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredDevices.length,
                          itemBuilder: (context, index) {
                            final device = filteredDevices[index];
                            return ListTile(
                              title: Text(
                                "${device.deviceName}  ${device.switchNo}",
                                style: w500_14Poppins(),
                              ),
                              trailing: const Icon(Icons.arrow_right),
                              onTap: () => Navigator.pop(context, device),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (result != null) {
      onItemSelected(result);
    }
  }
}
