import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';
import 'package:utility/utils/app_fonts.dart';

class RemoveDeviceBottomsheet extends StatefulWidget {
  const RemoveDeviceBottomsheet({super.key});

  @override
  State<RemoveDeviceBottomsheet> createState() =>
      _RemoveDeviceBottomsheetState();
}

class _RemoveDeviceBottomsheetState extends State<RemoveDeviceBottomsheet> {
  final _formSpaceKey = GlobalKey<FormState>();
  int? selectedIndex;
  String? selectedDeviceName;
  String? selectedDeviceId;

  late SpacesProvider spacesProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);
    // spacesProvider.setLoading(true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpacesProvider>(
      builder: (context, spaceProvider, child) {
        return Form(
          key: _formSpaceKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                height10,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffEBEBEB),
                    ),
                  ),
                ),
                height10,
                Text(
                  "Select devices you want to remove from the space",
                  style: w500_16Poppins(color: const Color(0xff11271D)),
                ),
                height20,
                FutureBuilder<GetAllDevicesBySpaceIdModel?>(
                  future: spacesProvider.getDevicesBySpaceId(context),
                  builder: (context, snapshot) {
                   if (snapshot.hasError || snapshot.data == null) {
      return Center(
        child: Text(
          'Failed to load devices or please select a space',
          style: w400_15Poppins(color: Colors.black),
        ),
      );
    }

    // Deduplicate devices     by deviceId
    List<Device> originalDevicesList = snapshot.data!.data.devices;
    final seenIds = <String>{};
    List<Device> devicesList = originalDevicesList.where((device) {
      final isNew = !seenIds.contains(device.deviceId);
      seenIds.add(device.deviceId);
      return isNew;
    }).toList();

    if (devicesList.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Text(
          "No Device Found",
          style: w700_28Poppins(color: Colors.black),
        ),
      );
    }


                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3
                            / 1.5,
                          ),
                      itemCount: devicesList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              selectedDeviceName =
                                  devicesList[index].deviceName;
                              selectedDeviceId = devicesList[index].deviceId;
                              print(
                                "Selected: $selectedDeviceName, $selectedDeviceId",
                              );
                            });
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              // color: Colors.white,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Appcolors.appColor),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          devicesList[index].deviceName,
                                          style: w500_15Poppins(),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                CustomButton(
                  width: 160.w,
                  height: 35.h,
                  borderRadius: 24,
                  buttonColor: Color.fromARGB(255, 237, 228, 203),
                  buttonTextStyle: w500_16Poppins(color: Colors.black),
                  buttonText: "Remove device",
                  onTap: () {
                    if (selectedIndex != null &&
                        selectedDeviceName != null &&
                        selectedDeviceId != null) {
                      removeDevice(
                        selectedIndex!,
                        context,
                        selectedDeviceName!,
                        selectedDeviceId!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a device to remove"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeDevice(int index, BuildContext context, String title, String id) {
    showModalBottomSheet(
      backgroundColor: const Color(0xffFBFAF5),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Consumer<SpacesProvider>(
          builder: (context, spaceProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                height10,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffEBEBEB),
                    ),
                  ),
                ),
                height10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Are you sure you want to remove the device $title?",
                      style: w500_15Poppins(),
                    ),
                    height15,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          width: 160.w,
                          height: 35.h,
                          borderRadius: 24,
                          buttonColor: const Color(0xffE7E9E8),
                          buttonTextStyle: w500_16Poppins(color: Colors.black),
                          buttonText: "No",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        width10,
                        CustomButton(
                          width: 160.w,
                          height: 35.h,
                          buttonColor: Appcolors.appColor,
                          borderRadius: 24,
                          buttonText: "Yes, Remove",
                          onTap: () {
                            spaceProvider.deleteDevice(id, context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                height10,
              ],
            );
          },
        );
      },
    );
  }
}
