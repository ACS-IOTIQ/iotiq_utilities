import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utility/ui/devices/device_wifiSetupTank.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';
class TankDeviceCapacityScreen extends StatefulWidget {
 const TankDeviceCapacityScreen({ super.key,
    required this.imageUrl,
    required this.itemName,
    required this.deviceId,
    required this.device,
    required this.sensorNo
  });
  final String itemName;
  final String imageUrl;
  final String sensorNo;
  final String deviceId;
  final BluetoothDevice device;
 @override
 State<TankDeviceCapacityScreen> createState() => _TankDeviceCapacityScreenState();
}
class _TankDeviceCapacityScreenState extends State<TankDeviceCapacityScreen> {
 double _currentHeight = 50.0;
 double _currentCapacity = 10.0;
 final TextEditingController rangeController = TextEditingController();
 final TextEditingController capacityController = TextEditingController();
 @override
 void initState() {
   super.initState();
   rangeController.text = _currentHeight.toStringAsFixed(1);
   capacityController.text = _currentCapacity.toStringAsFixed(1);
 }
 @override
 void dispose() {
   rangeController.dispose();
   capacityController.dispose();
   super.dispose();
 }
 @override
 Widget build(BuildContext context) {
   return  SingleChildScrollView(
     child: Padding(
        padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             const SizedBox(height: 20),
                 _buildTankVisual(),
         
           
             const SizedBox(height: 30),
             // Text Fields for Height and Capacity
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: Colors.grey[100],
                 borderRadius: BorderRadius.circular(12),
               ),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Height Text Field
                      Text(
                                    'Range (cm)',
                                    style: w500_15Poppins(
                                      color: Colors.black,
                                    ),
                                  ),
                                  height10,
                                 
                   TextFormField(
                            style: w400_14Poppins(color: Colors.black),
         
                     controller: rangeController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                     
                       labelStyle: w400_16Poppins(
                                      color: Colors.black,
                                    ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Appcolors.appColor, width: 1),
                       ),
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Appcolors.appColor, width: 1),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Appcolors.appColor, width: 1),
                       ),
                       filled: true,
                       fillColor: Colors.white,
                     ),
                     onChanged: (value) {
                       final newValue = double.tryParse(value);
                       if (newValue != null && newValue >= 10 && newValue <= 200) {
                         setState(() {
                           _currentHeight = newValue;
                         });
                       }
                     },
                   ),
                   height10,
                  Text(
                                    'Capacity (Liters)',
                                    style: w500_15Poppins(
                                      color: Colors.black,
                                    ),
                                  ),
                                  height10,
                   TextFormField(
                     controller: capacityController,
                            style: w400_14Poppins(color: Colors.black),
         
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                      labelStyle: w400_16Poppins(
                                      color: Colors.black,
                                    ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Appcolors.appColor, width: 1),
                       ),
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Appcolors.appColor, width: 1),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Appcolors.appColor, width: 1),
                       ),
                       filled: true,
                       fillColor: Colors.white,
                     ),
                   
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 30),
             // Save Button
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: (){
                  _confirmationPopup(context);
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Appcolors.appColor,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8),
                   ),
                 ),
                 child: const Text(
                   'Save Module Settings',
                   style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }
 // Build Tank Visual
 Widget _buildTankVisual() {
   double capacityPercentage = (_currentCapacity - 1) / 49;
   return Column(
     children: [
       Container(
         width: 100,
         height: 200,
         decoration: BoxDecoration(
           color: Colors.blue[100],
           borderRadius: BorderRadius.circular(12),
           border: Border.all(color: Colors.blue[800]!, width: 3),
         ),
         child: Stack(
           children: [
             // Water level
             Align(
               alignment: Alignment.bottomCenter,
               child: Container(
                 width: double.infinity,
                 height: 200 * capacityPercentage,
                 decoration: BoxDecoration(
                   color: Colors.blue[400]!.withOpacity(0.7),
                   borderRadius: const BorderRadius.only(
                     bottomLeft: Radius.circular(9),
                     bottomRight: Radius.circular(9),
                   ),
                 ),
               ),
             ),
             // Shine effect
             Positioned(
               left: 10,
               top: 20,
               child: Container(
                 width: 15,
                 height: 160,
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.3),
                   borderRadius: BorderRadius.circular(4),
                 ),
               ),
             ),
           ],
         ),
       ),
       const SizedBox(height: 8),
       const Text(
         'Tank Module',
         style: TextStyle(
           fontSize: 12,
           fontWeight: FontWeight.bold,
         ),
       ),
     ],
   );
 }

 void _confirmationPopup(BuildContext context) {
     showModalBottomSheet(
      backgroundColor: Color(0xffFBFAF5),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
       builder: (BuildContext context) {
        return  Column(
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
                    color: const Color(0xffEBEBEB)),
              ),
            ),
            height10,
          Column(
              children: [
                  SizedBox(
                  width: 310.w,
                  height: 60.h,
                  child: Text("Are you sure the height and capacity of the tank are correct?",style: w400_15Poppins(),)),
              Row(
                children: [
                  CustomButton(
                    width: 160.w,
                    height: 35.h,
                    borderRadius: 24,
                    buttonColor: Color(0xffE7E9E8),
                    buttonTextStyle: w500_16Poppins(color: Colors.black),
                    buttonText: "No",onTap: (){
                    Navigator.pop(context);
                  },),
                  width10,
                   CustomButton(
                    width: 160.w,
                    height: 35.h,
                    buttonColor: Appcolors.appColor,
                    borderRadius: 24,
                    buttonText: "Yes",onTap:(){
 print('Height saved: $_currentHeight cm');
   print('Capacity saved: $_currentCapacity Liters');
 
   Navigator.push(context, MaterialPageRoute(builder: (context)=>  DeviceWifisetuptank(
                  device: widget.device,
                  sensorNo: widget.sensorNo,
                  itemName: widget.itemName,
                  imageUrl: widget.imageUrl,
                  deviceId: widget.deviceId,
                  range: int.tryParse(rangeController.text) ?? 0,
      capacity: int.tryParse(capacityController.text) ?? 0,

                ),));
                    },)
                ],
              )
              ],
            ),
        
            height10,
          ],
        );}
     );
  }
}