import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utility/ui/usage/deviceUsage_widget.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';
class TodayusageScreen extends StatefulWidget {
  const TodayusageScreen({super.key});

  @override
  State<TodayusageScreen> createState() => _TodayusageScreenState();
}

class _TodayusageScreenState extends State<TodayusageScreen> {
   bool isSelected = false;
   final List<String> items = ['Apple', 'Banana', 'Mango', 'Orange'];
  String? selectedValue;
  double progressMotor = 0.39;
  double progressTv = 0.28;
  double progressCurtain = 0.64;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height20,
            Text("Total Water Usage",style: w500_14Poppins(color: Color(0xff11271D)),),
            height10,
            TotalWaterUsageUI()
         ,height10,
         Row(
          children: [
            Text("Device Activity (12 Active)",style: w500_14Poppins(color: Color(0xff11271D)),),
            width20,
             Radio<bool>(
              value: true,
              groupValue: isSelected ? true : null,
              activeColor:Color(0xffC39C67) ,
              onChanged: (value) {
                setState(() {
                  isSelected = !isSelected;
                });
              },
            ),
            Text('Active Devices',style: w400_13Poppins(color: Color(0xff11271D)),),
          ],
         ),
         Row(
          children: [
            Container(
              width: 140.w,
              height: 40.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(28),color: Colors.white),
              child:  DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                          hint: Text('Spaces'),
                          value: selectedValue,
                          iconStyleData: IconStyleData(iconEnabledColor: Color(0xffC39C67)),
                          onChanged: (value) {
                            setState(() {
                selectedValue = value;
                            });
                          },
                          items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,style: w500_12Poppins(color: Color(0xff11271D)),),
                    ))
                .toList(),
                          buttonStyleData: const ButtonStyleData(
                            height: 50,
                            width: 160,
                            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                            )
                          ),
                         
                        ),
              ),
            ),
            width10,
             Container(
              width: 140.w,
              height: 40.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(28),color: Colors.white),
              child:  DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                          hint: Text('Spaces'),
                          value: selectedValue,
                          iconStyleData: IconStyleData(iconEnabledColor: Color(0xffC39C67)),
                          onChanged: (value) {
                            setState(() {
                selectedValue = value;
                            });
                          },
                          items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,style: w500_12Poppins(color: Color(0xff11271D)),),
                    ))
                .toList(),
                          buttonStyleData: const ButtonStyleData(
                            height: 50,
                            width: 160,
                            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                            )
                          ),
                         
                        ),
              ),
            )
          ],
         )
          ,height10,
          DeviceUsageWidget(progressValue: 0.39, title: "Main Motor",icon: Icons.lightbulb_outline_rounded,isVisible: false,),
          height10,
          DeviceUsageWidget(progressValue: 0.24, title: "Televisions",icon: Icons.tv,isVisible: false,),
            height10,
          DeviceUsageWidget(progressValue: 0.64,title:"Curtains",icon: Icons.curtains_outlined,isVisible:  false,),
          height60,
          ],
        ),
      ) ,
    );
  }
}



class TotalWaterUsageUI extends StatefulWidget {
  const TotalWaterUsageUI({
    super.key,
  });

  @override
  State<TotalWaterUsageUI> createState() => _TotalWaterUsageUIState();
}

class _TotalWaterUsageUIState extends State<TotalWaterUsageUI> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
        AspectRatio(
      aspectRatio: 1.3,
      child:LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 6,
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('Day ${value.toInt()}');
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black26),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 2),
                FlSpot(2, 5),
                FlSpot(3, 3.1),
                FlSpot(4, 4),
                FlSpot(5, 3),
                FlSpot(6, 4),
              ],
            ),
          ],
        ),
      ),),
            Divider(),
            Row(
              children: [
                Container(width: MediaQuery.of(context).size.width*0.4,height: 100.h,
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Color(0xffF8F8F8)),
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height10,
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "10",style: w600_18Poppins(color: Color(0xffC39C67))),
                          TextSpan(text: " UNITS",style: w400_14Poppins(color: Colors.black87)),
                        ]
                      )),
                      height10,
                      SizedBox(
                        width: 124.w,
                        height: 28.h,
                        child: Text("Today’s power consumption",style: w300_13Poppins(color: Color(0xff11271D)),),
                      )
                   
                    ],
                   ),
                 ),
                 ),
                 width10,
                   Container(width: MediaQuery.of(context).size.width*0.4,height: 100.h,
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Color(0xffF8F8F8)),
                   child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height10,
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "6",style: w600_18Poppins(color: Color(0xffC39C67))),
                          TextSpan(text: " UNITS",style: w400_14Poppins(color: Colors.black87)),
                        ]
                      )),
                      height10,
                      SizedBox(
                        width: 124.w,
                        height: 28.h,
                        child: Text("Yesterday's power consumption",style: w300_13Poppins(color: Color(0xff11271D)),),
                      )
                  
                    ],
                   ),
                 ),
                 ),
                 
              ],
            ),
            height5,
          ],
        ),
      ),
    );
  }
}



