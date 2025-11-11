// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/manage_devices/device_card.dart';
import 'package:utility/manage_devices/device_section.dart';
import 'package:utility/model/devices/get_all_devices_model.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';
class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final List <String> tabs=["All","ACS Home","Space A","Space B"];

  List<Datum> devices = [];

  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        // automaticallyImplyLeading: true,
      backgroundColor: Colors.white,

        leading: IconButton(icon: const Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.pop(context);
        },),
        title:  Column(
          children: [
            Text("Devices",
              style: w500_16Poppins(color: Colors.black),),
          ],
        ),
        centerTitle: true,
        elevation:  0,
      ),

      body: Consumer2<SpacesProvider,CommonProvider>(
        builder: (context,spacesProvider,provider,child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: tabs.map((tab){
              //       bool isSelected = tab==selectedTab;
              //       return Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: ChoiceChip(
                      
              //           showCheckmark: false,
              //           disabledColor:Color(0xffF5F1E5) ,
              //           label:Text(tab,
              //             style: w500_13Poppins(color: isSelected?Colors.white:Colors.black)),
              //           selected:isSelected,
              //           selectedColor:const Color(0xffC39C67),
              //           side: BorderSide(color: Colors.transparent),
              //           onSelected:(value){
              //             setState(() {
              //               selectedTab =tab;
              //             });
              //           },
              //         ),
              //       );
              //     }).toList(),
              //   ),
          
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text("List of Devices",style: w400_16Poppins(color: Colors.black),),
              ),
              height5,
           FutureBuilder<GetAllDevicesModel?>(
            future: spacesProvider.fetchDevices(provider.userId,context),
            builder: (context, snapshot) {
              if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Text('Failed to load spaces.',style: w400_15Poppins(color: Colors.black),));
              }
              if(snapshot.data!.data.isEmpty){
                return Center(child: Text('Data not found',style: w400_15Poppins(color: Colors.black),));
              } 
                final List<Datum> devices = snapshot.data!.data;
          
                return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  childAspectRatio: 3/1.37
                                ),
                                itemCount: devices.length, // Total number of items
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onTap: (){
                                       
                                      },
                                      child: Container(
                                        height: 160.h,
                                        width:160.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                                border: Border.all(color: Appcolors.appColor)
                                              ),
                                          child: 
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "${devices[index].deviceName}",
                                                                      style:w400_15Poppins(color: Colors.black),
                                                                    ),
                                                                    height5,
                                                                    Text("${devices[index].deviceType}",style: w300_14Poppins(),)
                                                                    
                                                                  ],
                                                                ),
                                                                Icon(Icons.curtains,color: Appcolors.appColor,)
                                                  ],
                                                ),
                                              ),
                                              
                                          ),
                                    ),
                                  );
                                },
                              );
              }
            ),
            ],
          
          );
        }
      ),
       bottomNavigationBar: Consumer<CommonProvider>(
          builder: (context,commonProvider,child) {
            return Padding(padding: EdgeInsets.only(bottom: 20),
              child:
             Container(
                  height: 58.h,
                 color: Colors.white,
                   padding:const EdgeInsets.all(16),
                  child: ElevatedButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen(startIndex: 0,showBottomSheet: true,phoneNumber: commonProvider.userName ,)));
                  },
              icon:const Icon(Icons.add,color: Color(0xffC39C67),),
              label: Text("Add New Device",
                style: w500_14Poppins(color: Colors.black)) ,
              style: ElevatedButton.styleFrom(
                  backgroundColor:Color.fromARGB(255, 237, 228, 203),
                  elevation:0,
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20,
                    ),
            
                  ))
                  ),
                ));
          }
        )
    );
  }
  List<Widget> buildDeviceSections(){
    final allSections=[
     const  DeviceSection(
        title:"ACS Home",
        rooms:{
          "Living Room":[
            DeviceCard(iconPath:Icons.mode_fan_off_rounded,name:"Fan 1",brand:"Phillips"),
            DeviceCard(iconPath:Icons.lightbulb,name:"Main Light",brand:"Phillips"),],
          "Study Room":[
            DeviceCard(iconPath: Icons.ac_unit_outlined,name:"Room's AC",brand: "Samsung"),
            DeviceCard(iconPath:Icons.light_rounded ,name:"Lamp",brand:"Phillips"),
          ],
          "Dining Hall":[
            DeviceCard(iconPath:Icons.ac_unit_outlined,name:"Hall's AC",brand:"Voltas"),
          ],
        },
      ),
      const DeviceSection(
        title:"Space A",
        rooms:{
          "Main Bedroom":[
            DeviceCard(iconPath: Icons.mode_fan_off,name:"Havel's fan",brand:"Havel's"),
          ]
        },
      ),
      const DeviceSection(
        title:"Space B",
        rooms:{
          "kids Bedroom":[
            DeviceCard(iconPath: Icons.lightbulb,name:"Mood Lights",brand:"Phillips"),
            DeviceCard(iconPath: Icons.lightbulb,name:"Playzone Lights",brand:"Phillps"),

          ],
        },
      ),
    ];
    final filteredSections = selectedTab=="All"? allSections:allSections.where((section)=>section.title==selectedTab).toList();
    return filteredSections.expand((section){
      return[
        section,
        const Padding(padding: EdgeInsets.symmetric(horizontal:16.0 ),
          child: Divider(
            color: Colors.brown,
            thickness: 1,
          ),)
      ];
    }).toList();


  }


}
