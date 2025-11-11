import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/manage_devices/devicepage.dart';
import 'package:utility/manage_devices/manage_spaces.dart';
import 'package:utility/profile/profile.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/ui/setup/manage_setups.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class Customdrawer extends StatefulWidget {
  const Customdrawer({super.key});

  @override
  State<Customdrawer> createState() => _CustomdrawerState();
}

class _CustomdrawerState extends State<Customdrawer> {
  late CommonProvider commonProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commonProvider = Provider.of<CommonProvider>(listen: false, context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonProvider>(builder: (context, provider, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width*0.85,
        child: Drawer(
            child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height50,
              DrawerTileInfo(
                  title: "Profile",
                  subTitle: "Add details, Manage Profiles",
                  image: AppImages.profileIcon,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            phoneNumber: provider.phoneController.text,
                          ),
                        ));
                  }),
              Divider(),
             
                DrawerTileInfo(
                  title: "Devices",
                  subTitle: "Manage devices added to your space",
                  image: AppImages.devicesDrawer,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DevicePage()));
                  }),
              Divider(),
               DrawerTileInfo(
                  title: "Setups",
                  subTitle: "Add, Delete or Manage Setups",
                  image: AppImages.notification,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ManageSetups()));
                  }),
              height40,
              Text(
                "General",
                style: w400_12Poppins(color: Color(0xff11271D)),
              ),
              height10,
                DrawerTileInfo(
                  title: "Learn How to Use IOTIQ",
                  subTitle: "Quick learn from walkthrough videos",
                  image: AppImages.learnnIcon,
                  onTap: () {
                  
                  }),
              Divider(),
              //  DrawerTileInfo(
              //     title: "Support",
              //     subTitle: "Connect with our support",
              //     image: AppImages.support,
              //     onTap: () {
                  
              //     }),
            
              // Divider(),
              //   DrawerTileInfo(
              //     title: "Buy IOTIQ Products",
              //     subTitle: "Add more smart devices to your space",
              //     image: AppImages.buyIcon,
              //     onTap: () {
                  
              //     }),
             
              // Divider(),
              Spacer(),
              InkWell(
                onTap: () {
                  provider.logout(context);
//                       Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (_) => LandingScreen()),
//   (route) => false,
// );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 237, 228, 203)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        width10,
                        Text(
                          "Logout",
                          style: w500_14Poppins(color: Color(0xff11271D)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      );
    });
  }

  Padding DrawerTileInfo({
    required String title,
    required String subTitle,
    required String image,
    required VoidCallback onTap,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1),
        child: SizedBox(
        
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(image),
                  width10,
                  Consumer<CommonProvider>(builder: (context, provider, child) {
                    return InkWell(
                      onTap: onTap,
                      child: SizedBox(
                        width:MediaQuery.of(context).size.width*0.569,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: w500_14Poppins(color: Color(0xff11271D)),
                            ),
                            Text(
                              subTitle,
                              style: w400_12Poppins(color: Color(0xff11271D)),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  width10,
                  //Icon(Icons.arrow_forward_ios_outlined,color:  Colors.black26,)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black26,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
