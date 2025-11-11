
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/custom_toast.dart';
import 'package:utility/utils/images.dart';
import 'package:utility/utils/app_fonts.dart';
class DevicesBaseScreen extends StatefulWidget {
  const DevicesBaseScreen({super.key});

  @override
  State<DevicesBaseScreen> createState() => _DevicesBaseScreenState();
}

class _DevicesBaseScreenState extends State<DevicesBaseScreen> {
  late SpacesProvider spacesProvider;
  Future<GetAllDevicesBySpaceIdModel?>? _devicesFuture;

  @override
  void initState() {
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(context, listen: false);
    _devicesFuture = spacesProvider.getDevicesBySpaceId(context).then((
      model,
    ) async {
      // final baseDevices = model?.data.devices
      //     .where((device) => device.deviceType!.toLowerCase() == "base")
      //     .toList();

      // if (baseDevices != null) {
      //   await Future.wait(
      //     baseDevices.map((device) {
      //       return spacesProvider.baseSensors(
      //         context,
      //         device.deviceId,
      //         device.switchNo,
      //       );
      //     }),
      //   );
      // }

      return model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<SpacesProvider>(
        builder: (context, spaceProvider, child) {
          return Column(
            children: [
              FutureBuilder<GetAllDevicesBySpaceIdModel?>(
                future: _devicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center();
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return Center(
                      child: Text(
                        'Failed to load devices or please select a space',
                        style: w400_15Poppins(color: Colors.black),
                      ),
                    );
                  }

                  final baseDevices = snapshot.data!.data.devices
                      .where(
                        (device) => device.deviceType.toLowerCase() == "base",
                      )
                      .toList();

                  if (baseDevices.isEmpty) {
                    return Center(
                      child: Text(
                        'No devices found',
                        style: w400_15Poppins(color: Colors.black),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // childAspectRatio: 3 / 3.71,
                        ),
                    itemCount: baseDevices.length,
                    itemBuilder: (context, index) {
                      final device = baseDevices[index];
                      final deviceId = device.deviceId;
                      final switchNo = device.switchNo;
                      final key = '$deviceId-$switchNo';
                      // final sensorStatus = spaceProvider
                      //     .deviceSensorData[key]
                      //     ?.status
                      //     ?.toLowerCase();

                      final sensorData = spaceProvider.deviceSensorData[key];
                      final currentState =
                          sensorData?.status?.toLowerCase() == 'on';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            final newState = !currentState;
                            final status = newState ? "on" : "off";

                            try {
                              await spaceProvider.controllerBaseDevices(
                                deviceId: deviceId,
                                switchNo: switchNo,
                                status: status,
                                context: context,
                              );

                              // Update the local map immediately
                              final key = '$deviceId-$switchNo';
                              if (spaceProvider.deviceSensorData.containsKey(
                                key,
                              )) {
                                spaceProvider.deviceSensorData[key]?.status =
                                    status;
                              }

                              setState(() {}); // Refresh UI instantly

                              // 🔁 Refresh accurate status from server after a short delay
                              // Future.delayed(
                              //   const Duration(milliseconds: 500),
                              //   () async {
                              //     await spaceProvider.baseSensors(
                              //       context,
                              //       deviceId,
                              //       switchNo,
                              //     );
                              //   },
                              // );
                            } catch (e) {
                              print("Error controlling device: $e");
                              CustomToast.showErrorToast(
                                msg: "Failed to control device",
                              );
                            }
                          },

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentState
                                  ? const Color.fromARGB(255, 87, 119, 87)
                                  : Colors.white,
                              border: Border.all(
                                color: currentState
                                    ? Colors.transparent
                                    : Appcolors.appColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppImages.electricMotor,
                                    height: 70.h,
                                  ),
                                  height5,
                                  Text(
                                    "${device.deviceName} - ${device.switchNo}",
                                    style: w400_15Poppins(
                                      color: currentState
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentState ? 'On' : 'Off',
                                        style: w600_16Poppins(
                                          color: currentState
                                              ? const Color(0xffBAF8BC)
                                              : Colors.black,
                                        ),
                                      ),
                                      width5,
                                      SvgPicture.asset(
                                        AppImages.vector,
                                        color: currentState
                                            ? Colors.white
                                            : Colors.black,
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height * 0.72,
              //     child: ListView.builder(
              //       padding: const EdgeInsets.all(8),
              //       itemCount: 3, // Replace with dynamic tank count
              //       itemBuilder: (context, tankIndex) {
              //         return Container(
              //           margin: const EdgeInsets.only(bottom: 16),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8),
              //             color: Colors.white,
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 /// Tank name
              //                 Text(
              //                   "Bank ${tankIndex + 1}", // Replace with actual name
              //                   style: w500_16Poppins(color: Colors.black),
              //                 ),
              //                 const SizedBox(height: 8),

              //                 /// Sensors Grid
              //                 GridView.builder(
              //                   shrinkWrap: true,
              //                   physics:
              //                       const NeverScrollableScrollPhysics(), // Prevent nested scroll
              //                   gridDelegate:
              //                       const SliverGridDelegateWithFixedCrossAxisCount(
              //                         crossAxisCount: 2,
              //                         childAspectRatio: 3 / 2.7,
              //                         crossAxisSpacing: 8,
              //                         mainAxisSpacing: 8,
              //                       ),
              //                   itemCount:
              //                       2, // Replace with dynamic sensor count
              //                   itemBuilder: (context, sensorIndex) {
              //                     return Card(
              //                       color: Colors.white,
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(8),
              //                         side: BorderSide(
              //                           color: Appcolors.appColor,
              //                         ),
              //                       ),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                         children: [
              //                           Center(
              //                             child: Text(
              //                               "Assign switch",
              //                               style: w400_14Poppins(),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              height40,
            ],
          );
        },
      ),
    );
  }
}
