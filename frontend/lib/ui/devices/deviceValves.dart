import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/utils/images.dart';
import 'package:utility/utils/app_fonts.dart';

class DeviceValvesScreen extends StatefulWidget {
  const DeviceValvesScreen({super.key});

  @override
  State<DeviceValvesScreen> createState() => DeviceValvesScreenState();
}

class DeviceValvesScreenState extends State<DeviceValvesScreen> {
  List<bool> isOn = [false, true, true];


  void refreshData() {
    final spaceProvider = Provider.of<SpacesProvider>(context, listen: false);
    spaceProvider.getDevicesBySpaceId(context);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            height20,
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio: 3 / 2.9,
              ),
              itemCount: 3, // Total number of items
              itemBuilder: (context, index) {
                bool currentState = isOn[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isOn[index] = !currentState;
                      });
                    },
                    child: Container(
                      height: 160.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentState
                            ? const Color.fromARGB(255, 87, 119, 87)
                            : Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(AppImages.naturalGas),
                                height10,
                                Text(
                                  currentState
                                      ? "Main Motor 2"
                                      : "Home Valve 1",
                                  style: w400_14Poppins(
                                    color: currentState
                                        ? Colors.white
                                        : const Color(0xff11217D),
                                  ),
                                ),
                                height5,
                                Text(
                                  currentState ? 'On' : 'Off',
                                  style: w600_16Poppins(
                                    color: currentState
                                        ? const Color(0xffBAF8BC)
                                        : const Color(0xff11217D),
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              AppImages.vector,
                              color: currentState ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
