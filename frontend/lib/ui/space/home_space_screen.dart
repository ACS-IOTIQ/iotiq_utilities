import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/devices/get_all_devicesbyId_model.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/devices/searchingBase_device.dart';
import 'package:utility/ui/space/add_device.dart';
import 'package:utility/ui/space/setUpSpace_bottomSheet.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_bottomsheet.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/custom_toast.dart';
import 'package:utility/utils/images.dart';

class HomeSpaceScreen extends StatefulWidget {
  const HomeSpaceScreen({super.key});
  @override
  State<HomeSpaceScreen> createState() => HomeSpaceScreenState();
}

class HomeSpaceScreenState extends State<HomeSpaceScreen>
    with SingleTickerProviderStateMixin {
  List<bool> isOnList = [];
  late SpacesProvider spacesProvider;
  late final AnimationController _controller;
  Future<GetAllDevicesBySpaceIdModel?>? _devicesFuture;

  @override
  void initState() {
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slower = longer duration
    )..repeat();
    _devicesFuture = spacesProvider.getDevicesBySpaceId(context).then((model) {
      final tankDevices = model?.data.devices
          .where((device) => device.deviceType.toLowerCase() == "tank")
          .toList();

      // Fetch sensors only once for each tank
      if (tankDevices != null) {
        for (var tank in tankDevices) {
          spacesProvider.tankSensors(
            context,
            tank.parentDeviceId,
            tank.slaveName,
          );
        }
      }

      final baseDevices = model?.data.devices
          .where((device) => device.deviceType.toLowerCase() == "base")
          .toList();

      // Fetch sensors only once for each tank
      if (baseDevices != null) {
        for (var base in baseDevices) {
          spacesProvider.baseSensors(context, base.deviceId, base.switchNo);
        }
      }

      return model;
    });

    spacesProvider = Provider.of<SpacesProvider>(context, listen: false);

    if (spacesProvider.selectedSpaceId == null) {
      spacesProvider.initializeDefaultSpace(context).then((_) {
        loadDevices();
      });
    } else {
      loadDevices();
    }
  }

  void loadDevices() {
    _devicesFuture = spacesProvider.getDevicesBySpaceId(context).then((model) {
      // fetch sensors logic...
      return model;
    });
  }

  Future<void> fetchData() async {
    print("fetchData started");
    final spacesProvider = Provider.of<SpacesProvider>(context, listen: false);
    setState(() {
      _devicesFuture = spacesProvider.getDevicesBySpaceId(context).then((
        model,
      ) {
        final tankDevices = model?.data.devices
            .where((device) => device.deviceType.toLowerCase() == "tank")
            .toList();

        if (tankDevices != null) {
          for (var tank in tankDevices) {
            spacesProvider.tankSensors(
              context,
              tank.parentDeviceId,
              tank.slaveName,
            );
          }
        }

        final baseDevices = model?.data.devices
            .where((device) => device.deviceType.toLowerCase() == "base")
            .toList();

        if (baseDevices != null) {
          for (var base in baseDevices) {
            spacesProvider.baseSensors(context, base.deviceId, base.switchNo);
          }
        }

        return model;
      });
    });

    await _devicesFuture;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_devicesFuture == null &&
        Provider.of<SpacesProvider>(context, listen: false).selectedSpaceId !=
            null) {
      fetchData(); // Fixes the hot reload case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonProvider, SpacesProvider>(
      builder: (context, commonProvider, spaceProvider, child) {
        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: commonProvider.signUpSuccess == true
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height10,
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Good Morning, ",
                                  style: w700_24Poppins(color: Colors.black),
                                ),
                                TextSpan(
                                  text: "You!",
                                  style: w700_24Poppins(
                                    color: Appcolors.appColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height5,
                          Text(
                            "Let’s get your space set up.",
                            style: w500_15Poppins(color: Appcolors.textColor),
                          ),
                          height40,
                          Stack(
                            children: [
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  child: Image.asset(
                                    AppImages.homeEmptyScreen,
                                    width: 332.w,
                                    height: 400.h,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.05,
                                left: 115.w,
                                child: InkWell(
                                  onTap: () {
                                    customShowDialog(
                                      context,
                                      const SetupspaceBottomsheet(),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Setup Space ",
                                        style: w600_14Poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height10,
                          Row(
                            children: [
                              Text(
                                "Learn How to Setup Space",
                                style: w500_14Poppins(),
                              ),
                              const Icon(
                                Icons.arrow_right,
                                color: Color(0xffC39C67),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  :
                    // spaceProvider.getAllDevicesByIdModel!.data.id == null?Center(child: Text("Please select a space",style: w400_14Poppins(),)):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height5,
                        FutureBuilder<GetAllDevicesBySpaceIdModel?>(
                          future: _devicesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 41,
                                      backgroundColor: Color(0xffC39C67),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.phonelink_erase_rounded,
                                          color: Color(0xffC39C67),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    height20,
                                    Text(
                                      "No Device Found",
                                      style: w700_28Poppins(
                                        color: Colors.black,
                                      ),
                                    ),

                                    height10,
                                    SizedBox(
                                      width: 260.w,
                                      height: 50.h,
                                      child: Text(
                                        "No Devices added in the room so far. Add a device to make your Home Smart.",
                                        style: w400_16Poppins(
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    CustomButton(
                                      height: 35.h,
                                      width: 180.h,
                                      borderRadius: 18,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddDeviceScreen(),
                                          ),
                                        );
                                      },
                                      buttonText: "Add a new Device",
                                      textColor: Colors.white,
                                      buttonColor: const Color(0xffC39C67),
                                    ),
                                  ],
                                ),
                              );
                            }
                            // Deduplicate devices by device_id
                            final devicesList = snapshot.data!.data.devices;

                            // 🔁 Initialize ON/OFF list based on backend status
                            if (isOnList.length != devicesList.length) {
                              isOnList = devicesList.map((device) {
                                return device.status.toLowerCase() == 'on';
                              }).toList();
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 3.1,
                                  ),
                              itemCount: devicesList.length,
                              itemBuilder: (context, index) {
                                if (devicesList[index].deviceType == "base") {
                                  final device = devicesList[index];
                                  final deviceId = device.deviceId;
                                  final switchNo = device.switchNo;
                                  final key = '$deviceId-$switchNo';
                                  final sensorStatus = spaceProvider
                                      .deviceSensorData[key]
                                      ?.status
                                      ?.toLowerCase();

                                  final sensorData =
                                      spaceProvider.deviceSensorData[key];
                                  final currentState =
                                      sensorData?.status?.toLowerCase() == 'on';

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        final newState = !currentState;
                                        final status = newState ? "on" : "off";

                                        try {
                                          await spaceProvider
                                              .controllerBaseDevices(
                                                deviceId: deviceId,
                                                switchNo: switchNo,
                                                status: status,
                                                context: context,
                                              );

                                          final key = '$deviceId-$switchNo';
                                          if (spaceProvider.deviceSensorData
                                              .containsKey(key)) {
                                            spaceProvider
                                                    .deviceSensorData[key]
                                                    ?.status =
                                                status;
                                          }

                                          setState(() {});

                                          // Optional: still fetch fresh data in background
                                          Future.delayed(
                                            Duration(milliseconds: 500),
                                            () async {
                                              await spaceProvider.baseSensors(
                                                context,
                                                deviceId,
                                                switchNo,
                                              );
                                            },
                                          );
                                        } catch (e) {
                                          print("Error controlling device: $e");
                                          CustomToast.showErrorToast(
                                            msg: "Failed to control device",
                                          );
                                        }
                                      },

                                      child: 
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: currentState
                                              ? const Color.fromARGB(
                                                  255,
                                                  87,
                                                  119,
                                                  87,
                                                )
                                              : Colors.white,
                                          border: Border.all(
                                            color: currentState
                                                ? const Color.fromARGB(
                                                    255,
                                                    87,
                                                    119,
                                                    87,
                                                  )
                                                : Appcolors.appColor,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // height5,
                                              Image.asset(
                                                AppImages.electricMotor,
                                                height: 65.h,
                                              ),
                                              Text(
                                                "${device.deviceName} - ${device.switchNo}",
                                                style: w400_15Poppins(
                                                  color: currentState
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                currentState ? 'On' : 'Off',
                                                style: w500_15Poppins(
                                                  color: currentState
                                                      ? const Color(0xffBAF8BC)
                                                      : Colors.black,
                                                ),
                                              ),
                                              // Align(
                                              //   alignment: Alignment.bottomRight,
                                              //   child: SvgPicture.asset(
                                              //     AppImages.vector,
                                              //     color: currentState
                                              //         ? Colors.white
                                              //         : Colors.black,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  final currentDevice = devicesList[index];
                                  final parentId = currentDevice.parentDeviceId;
                                  final slaveName = currentDevice.slaveName;
                                  String key = '$parentId-$slaveName';

                                  String valueString =
                                      spaceProvider
                                          .tankSensorMap[key]
                                          ?.data
                                          ?.first
                                          .value
                                          ?.toString() ??
                                      '0';

                                  double percentageValue =
                                      (double.tryParse(valueString) ?? 0).clamp(
                                        0,
                                        100,
                                      );
                                  double containerHeight =
                                      MediaQuery.of(context).size.height * 0.5;
                                  double fillHeight =
                                      (containerHeight *
                                              (percentageValue / 100))
                                          .clamp(10.0, containerHeight);

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: containerHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Appcolors.appColor,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Water animation
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            height: fillHeight,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    bottom: Radius.circular(10),
                                                  ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 40.h,
                                                ),
                                                child: Lottie.asset(
                                                  AppImages.waterTankLottie,
                                                  controller: _controller,
                                                  fit: BoxFit.cover,
                                                  onLoaded: (composition) {
                                                    _controller.duration =
                                                        composition.duration *
                                                        5;
                                                    _controller.repeat();
                                                  },
                                                  alignment:
                                                      Alignment.bottomCenter,
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

                                          // Device name and sensor value
                                          Positioned(
                                            bottom: 20,
                                            left: 14,
                                            right: 14,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        currentDevice
                                                            .deviceName,
                                                        style: w500_15Poppins(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '$valueString%',
                                                        style: w500_15Poppins(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),

                        height10,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
