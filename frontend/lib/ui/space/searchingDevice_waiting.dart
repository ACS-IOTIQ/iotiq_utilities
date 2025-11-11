import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility/ui/devices/searchingBase_device.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class SearchingDeviceWaitingScreen extends StatefulWidget {
   SearchingDeviceWaitingScreen({super.key,required this.itemName,required this.imageUrl,required this.sensorNo});
  final String itemName;
  late String sensorNo;
  final String imageUrl;

  @override
  State<SearchingDeviceWaitingScreen> createState() => _SearchingDeviceWaitingScreenState();
}

class _SearchingDeviceWaitingScreenState extends State<SearchingDeviceWaitingScreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
     Future.delayed(
      const Duration(seconds: 3),() async{
        await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchingbaseScreen(itemName: widget.itemName,imageUrl: 
        widget.imageUrl,
        sensroNo: widget.sensorNo,)),);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("Searching for ${widget.itemName} Module",style: w400_16Poppins(),),
            height5,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bed_outlined,size: 16,color: Colors.black38,),
                width5,
                Text("jgdsg dhgh",style: w400_10Poppins(color: Colors.black54),)
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:   Column(
        children: [
          height70,
          height70,
          height70,

          Center(
            child: SvgPicture.asset(AppImages.appLogoOrange,height: 45,width: 45,),
          ),
          Spacer(),
          Text("Please make sure your device is in the setup mode",style: w400_14Poppins(color: Color(0xff11271D)),),
          height5,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Learn More",style: w500_14Poppins(),),
              width5,
              Icon(Icons.arrow_right,color: Color(0xffC39C67),size: 25,)
            ],
          )
        ],
      ),));
  }
}