import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/ui/space/add_device.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';
import 'package:utility/utils/app_fonts.dart';


class DeviceAddedScreen extends StatefulWidget {
  const DeviceAddedScreen({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.deviceId,
  });
  final String itemName;
  final String imageUrl;
  final String deviceId;

  @override
  State<DeviceAddedScreen> createState() => _DeviceAddedScreenState();
}

class _DeviceAddedScreenState extends State<DeviceAddedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Text(
              "Added to",
              style: w400_14Poppins(color: const Color(0xff11271D)),
            ),
            height5,
            Text(
              "Master Bedroom: First Floor",
              style: w400_10Poppins(color: const Color(0xff11271D)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // height40,
          Center(
            child: Expanded(
              child: Stack(
                children: [
                  SvgPicture.asset(AppImages.ripples),
                  SvgPicture.asset(AppImages.checkIcon),
                ],
              ),
            ),
          ),
          height10,
          Container(
            width: 86.w,
            height: 86.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            child: Image.asset(widget.imageUrl),
          ),
          height10,
          Text("IOTIQ ${widget.itemName} Module", style: w500_14Poppins()),
          height10,
          Text(
            widget.deviceId,
            style: w400_11Poppins(color: const Color(0xff11271D)),
          ),
          height40,
          CustomButton(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDeviceScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            buttonText: "Add More Devices",
            width: 330,
            buttonColor: const Color(0xffC39C67),
            borderRadius: 20,
          ),

          height20,
          Consumer<CommonProvider>(
            builder: (context, provider, child) {
              return InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homescreen(
                        startIndex: 0,
                        phoneNumber: provider.userName,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Continue to Home", style: w500_14Poppins()),
                    const Icon(
                      Icons.arrow_right_sharp,
                      color: Color(0xffC39C67),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
