
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/space/searchingDevice_waiting.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class DeviceTanksScreen extends StatefulWidget {
  const DeviceTanksScreen({super.key});

  @override
  State<DeviceTanksScreen> createState() => DeviceTanksScreenState();
}

class DeviceTanksScreenState extends State<DeviceTanksScreen>
    with SingleTickerProviderStateMixin {
  late SpacesProvider spacesProvider;
  late final AnimationController _controller;
  Future<GetAllDevicesBySpaceIdModel?>? _devicesFuture;
  late BluetoothDevice device;

  @override
  void initState() {
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slower = longer duration
    )..repeat();
    _devicesFuture = spacesProvider.getDevicesBySpaceId(context).then((model) {
      // final tankDevices = model?.data.devices
      //     .where((device) => device.deviceType.toLowerCase() == "tank")
      //     .toList();
      // Fetch sensors only once for each tank
      // if (tankDevices != null) {
      //   for (var tank in tankDevices) {
      //     print('➡️ tank.deviceId: ${tank.deviceId}');
      //     print('➡️ tank.parentDeviceId: ${tank.parentDeviceId}');
      //     print('➡️ slaveName: ${tank.slaveName}');

      //     spacesProvider.tankSensors(
      //       context,
      //       tank.parentDeviceId,
      //       tank.slaveName,
      //     );
      //   }
      // }

      return model;
    });
  }

  bool _isInit = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      spacesProvider = Provider.of<SpacesProvider>(context, listen: false);
      spacesProvider.getDevicesBySpaceId(context);
      _isInit = false;
    }
  }

  void refreshData() {
    final spaceProvider = Provider.of<SpacesProvider>(context, listen: false);
    spaceProvider.getDevicesBySpaceId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpacesProvider>(
      builder: (context, spaceProvider, child) {
        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                height10,
                // spaceProvider.getAllDevicesByIdModel == null?Center(child: Text("Please select a space",style: w400_14Poppins(),)):
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
                    if (snapshot.data!.data.devices.isEmpty) {
                      return Center(
                        child: Text(
                          'No devices found',
                          style: w400_15Poppins(color: Colors.black),
                        ),
                      );
                    }
                    final allDevices = snapshot.data!.data.devices;
                    final Map<String, Device> uniqueDeviceMap = {};

                    for (var device in allDevices) {
                      // Keeps the last device entry with a unique deviceId
                      uniqueDeviceMap[device.deviceId] = device;
                    }

                    List<Device> devicesList = uniqueDeviceMap.values.toList();

                    List<Device> tankDevices = devicesList
                        .where(
                          (device) => device.deviceType.toLowerCase() == "base",
                        )
                        .toList();
                    if (tankDevices.isEmpty) {
                      return Center(
                        child: Text(
                          'No devices found',
                          style: w400_15Poppins(color: Colors.black),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,

                        itemCount: tankDevices.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Builder(
                              builder: (context) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Tank name
                                        Text(
                                          tankDevices[index]
                                              .deviceName, // Replace with actual name
                                          style: w500_16Poppins(
                                            color: Colors.black,
                                          ),
                                        ),
                                        height10,

                                        /// Sensors Grid
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: 3 / 2.8,
                                                mainAxisSpacing: 8,
                                              ),
                                          itemCount:
                                              4, // fixed or dynamic count
                                          itemBuilder: (context, sensorIndex) {
                                            // Try to find a matching tank for this base device and slave
                                            final expectedSlaveName =
                                                'TM${sensorIndex + 1}';

                                            final matchingTank = allDevices.firstWhereOrNull(
  (device) =>
      device.deviceType.toLowerCase() == 'tank' &&
      device.parentDeviceId == tankDevices[index].deviceId &&
      (device.slaveName == null || device.slaveName == expectedSlaveName),
);


                                            if (matchingTank != null) {
                                              final parentId =
                                                  matchingTank.parentDeviceId;
                                              final slaveName =
                                                  matchingTank.slaveName;
                                              final key =
                                                  '$parentId-$slaveName';


  // ✅ Debug prints
  debugPrint('🔍 Key: $key');
  debugPrint('🔍   : ${matchingTank.level}');
  debugPrint('🔍 TankSensorMap Data: ${spaceProvider.tankSensorMap[key]}');

                                              final valueString = matchingTank.level?.toString() ?? '0';

                                              final percentageValue =
                                                  (double.tryParse(
                                                            valueString,
                                                          ) ??
                                                          0)
                                                      .clamp(0, 100);
                                              final containerHeight =
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.5;
                                              final fillHeight =
                                                  (containerHeight *
                                                          (percentageValue /
                                                              100))
                                                      .clamp(
                                                        10.0,
                                                        containerHeight,
                                                      );

                                              return Container(
                                                height: containerHeight,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Appcolors.appColor,
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    // Water level animation
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      height: fillHeight,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius.vertical(
                                                              bottom:
                                                                  Radius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 20,
                                                              ),
                                                          child: Lottie.asset(
                                                            AppImages
                                                                .waterTankLottie,
                                                            fit: BoxFit.cover,
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            controller:
                                                                _controller,
                                                            onLoaded: (composition) {
                                                              _controller
                                                                      .duration =
                                                                  composition
                                                                      .duration *
                                                                  5;
                                                              _controller
                                                                  .repeat();
                                                            },
                                                            delegates: LottieDelegates(
                                                              values: [
                                                                ValueDelegate.color(
                                                                  ['**'],
                                                                  value: Colors
                                                                      .blue
                                                                      .shade400,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Label and value
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            matchingTank
                                                                .deviceName,
                                                            style:
                                                                w500_15Poppins(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                          height5,
                                                          Text(
                                                            '$valueString%',
                                                            style:
                                                                w500_15Poppins(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                          height5,
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              // Show default InkWell with add icon
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchingDeviceWaitingScreen(
                                                            imageUrl: AppImages
                                                                .waterTank,
                                                            itemName: "Tank",
                                                            sensorNo: expectedSlaveName ,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: Appcolors.appColor,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            const Color(
                                                              0xffC39C67,
                                                            ),
                                                        child: CircleAvatar(
                                                          radius: 29,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(
                                                            Icons.add,
                                                            color: const Color(
                                                              0xffC39C67,
                                                            ),
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                      height10,
                                                      Center(
                                                        child: Text(
                                                          expectedSlaveName,
                                                          style:
                                                              w500_15Poppins(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                height70,
                height70,
                height70,
              ],
            ),
          ),
        );
      },
    );
  }
}



   // FutureBuilder<GetAllDevicesBySpaceIdModel?>(
                //   future: _devicesFuture,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center();
                //     }
                //     if (snapshot.hasError || snapshot.data == null) {
                //       return Center(
                //         child: Text(
                //           'Failed to load devices or please select a space',
                //           style: w400_15Poppins(color: Colors.black),
                //         ),
                //       );
                //     }
                //     if (snapshot.data!.data.devices.isEmpty) {
                //       return Center(
                //         child: Text(
                //           'No devices found',
                //           style: w400_15Poppins(color: Colors.black),
                //         ),
                //       );
                //     }
                //     List<Device> devicesList = snapshot.data!.data.devices;
                //     List<Device> tankDevices = devicesList
                //         .where(
                //           (device) => device.deviceType.toLowerCase() == "tank",
                //         )
                //         .toList();
                //     if (tankDevices.isEmpty) {
                //       return Center(
                //         child: Text(
                //           'No devices found',
                //           style: w400_15Poppins(color: Colors.black),
                //         ),
                //       );
                //     }
                //     return GridView.builder(
                //       shrinkWrap: true,
                //       gridDelegate:
                //           const SliverGridDelegateWithFixedCrossAxisCount(
                //             crossAxisCount: 2,
                //             // childAspectRatio: 3 / 3.1,
                //           ),
                //       itemCount: tankDevices.length,
                //       itemBuilder: (context, index) {
                //         return Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Builder(
                //             builder: (context) {
                //               String valueString =
                //                   spaceProvider
                //                       .tankSensorMap[tankDevices[index]
                //                           .parentDeviceId]
                //                       ?.data
                //                       ?.first
                //                       .value
                //                       ?.toString() ??
                //                   '0';

                //               double percentageValue =
                //                   (double.tryParse(valueString) ?? 0).clamp(
                //                     0,
                //                     100,
                //                   );
                //               double containerHeight =
                //                   MediaQuery.of(context).size.height * 0.5;
                //               double fillHeight =
                //                   (containerHeight * (percentageValue / 100))
                //                       .clamp(10.0, containerHeight);
                //               return Container(
                //                 height:
                //                     MediaQuery.of(context).size.height *
                //                     0.5, // Half the screen
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(10),
                //                   border: Border.all(color: Appcolors.appColor),
                //                 ),
                //                 child: Stack(
                //                   children: [
                //                     // Background image (bottom half)
                //                     Positioned(
                //                       bottom: 0,
                //                       left: 0,
                //                       right: 0,
                //                       height: fillHeight,
                //                       child: ClipRRect(
                //                         borderRadius:
                //                             const BorderRadius.vertical(
                //                               bottom: Radius.circular(10),
                //                             ),
                //                         child: Padding(
                //                           padding: const EdgeInsets.only(
                //                             top: 30,
                //                           ),
                //                           child: Lottie.asset(
                //                             AppImages.waterTankLottie,
                //                             fit: BoxFit.cover,
                //                             onLoaded: (composition) {
                //                               _controller.duration =
                //                                   composition.duration *
                //                                   5; // 2x slower
                //                               _controller.repeat();
                //                             },
                //                             alignment: Alignment.bottomCenter,
                //                             delegates: LottieDelegates(
                //                               values: [
                //                                 ValueDelegate.color(
                //                                   const [
                //                                     '**',
                //                                   ], // use actual key path from your Lottie file
                //                                   value: Colors
                //                                       .blue
                //                                       .shade300, // your desired color
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                     ),

                //                     // Text over image at bottom
                //                     Positioned(
                //                       bottom: 20,
                //                       left: 14,
                //                       right: 14,
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         children: [
                //                           Flexible(
                //                             child: Column(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.start,
                //                               children: [
                //                                 Text(
                //                                   tankDevices[index].deviceName,
                //                                   style: w500_15Poppins(
                //                                     color: Colors.white,
                //                                   ),
                //                                 ),
                //                                 const SizedBox(height: 4),
                //                                 Text(
                //                                   "$valueString%",

                //                                   style: w500_15Poppins(
                //                                     color: Colors.white,
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           SvgPicture.asset(
                //                             AppImages.vector,
                //                             color: Colors.black,
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               );
                //             },
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),
