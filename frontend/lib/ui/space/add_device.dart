import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/ui/space/searchingDevice_waiting.dart';
import 'package:utility/utils/appColors.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {

  final List<Map<String, String>>deviceInfo = [
    {"name":"Base Module","image": AppImages.motor},
    {"name":"Tank Module","image": AppImages.waterTank},
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<CommonProvider>(
      builder: (context,commonProvider,child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
          backgroundColor: Colors.white,
            leading: IconButton(onPressed: (){
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Homescreen(startIndex: 0,phoneNumber: commonProvider.userName,)), (Route<dynamic> route) => false,);
                 
            }, icon: Icon(Icons.arrow_back)),
            centerTitle: true,
            title:Text("Add a device",style: w400_16Poppins(),) ,
          ),
          body:   Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        childAspectRatio: 3/2.8
                      ),
                      itemCount: deviceInfo.length, // Total number of items
                      itemBuilder: (context, index) {
                        
                        return InkWell(
                          onTap: (){
                             String firstWord =  deviceInfo[index]['name']!.split(' ')[0];
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchingDeviceWaitingScreen(itemName: firstWord,imageUrl:  deviceInfo[index]['image']!,sensorNo: "TM1",)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 170.w,
                                height: 80.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffF8F8F8)),
                                child: Image.asset(deviceInfo[index]['image']!),
                              ),
                              height5,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(deviceInfo[index]['name']!,style: w500_14Poppins(),),
                                  width5,
                                  Icon(Icons.arrow_right,color: Appcolors.appColor,)
                                ],
                              ),
                              height5,
                            ],
                          ),
                          ),
                        );
                      },
                    ),
          ),
        );
      }
    );
  }
}

