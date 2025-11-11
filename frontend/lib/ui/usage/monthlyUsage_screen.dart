import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utility/ui/usage/deviceUsage_widget.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class MonthlyUsageScreen extends StatefulWidget {
  const MonthlyUsageScreen({super.key});

  @override
  State<MonthlyUsageScreen> createState() => _MonthlyUsageScreenState();
}

class _MonthlyUsageScreenState extends State<MonthlyUsageScreen> {
  List<BarChartGroupData> _buildBarGroups() {
    final List<double> values1 = [12, 10, 14, 13, 0]; // e.g. "This week"
    final List<double> values2 = [8, 12, 10, 11, 9]; // e.g. "Last week"

    return List.generate(values1.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values1[index],
            width: 12,
            color: Color(0xffC39C67),
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: values2[index],
            width: 10,
            color: Color(0xff22FFCA),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height20,
            // Container(
            //   height: 66.h,
            //   width: 333.w,
            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),image: DecorationImage(image: AssetImage(AppImages.backgroundImageUsage))),
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         height: 35.h,
            //         width: 222.w,
            //         child: RichText(text: TextSpan(children: [
            //           TextSpan(text: "You have saved ",style: w400_12Poppins(color: Colors.black)),
            //           TextSpan(text: "141.5 kWh",style: w500_12Poppins(color: Color(0xffC39C67))),
            //           TextSpan(text: " energy by using IOTIQ products this week.",style: w500_12Poppins(color: Colors.black)),
            //         ])),
            //       ),
            //       width20,
            //       SvgPicture.asset(AppImages.seedling)
            //     ],
            //   ),
           
            // ),
            height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Water Usage",
                  style: w500_14Poppins(color: Color(0xff11271D)),
                ),
                Row(
                  children: [
                    Container(
                      height: 10.h,
                      width: 10.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Color(0xffC39C67)),
                     
                    ),
                 
                width5,
                Text("THIS MONTH",style: w400_12Poppins(color: Color(0xff11217D)),),
                width10,
                 Container(
                  height: 10.h,
                  width: 10.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Color(0xff22FFCA)),
                 
                ),
                width5,
                Text("LAST MONTH",style: w400_12Poppins(color: Color(0xff11217D)),)
                 ],
                ),
              ],
            ),
            height10,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Color(0xffE5E5E599))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    AspectRatio(
                        aspectRatio: 1.3,
                        child: BarChart(
                          BarChartData(
                            maxY: 20,
                            barGroups: _buildBarGroups(),
                            gridData: FlGridData(show: true),
                            groupsSpace: 20,
                            borderData: FlBorderData(show: false),
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < days.length) {
                                      return Text(
                                        days[index],
                                        style: w400_10Poppins(
                                            color: Color(0xff11217D)),
                                      );
                                    } else {
                                      return Text('');
                                    }
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 5 == 0) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: w400_10Poppins(
                                            color: Color(0xff11217D)),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                          ),
                        )),
                    Divider(),
                    Row(
                      children: [
                        Container(
                          width: 138.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffF8F8F8)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "10",
                                      style: w600_18Poppins(
                                          color: Color(0xffC39C67))),
                                  TextSpan(
                                      text: " UNITS",
                                      style: w400_14Poppins(
                                          color: Colors.black87)),
                                ])),
                                height10,
                                SizedBox(
                                  width: 124.w,
                                  height: 28.h,
                                  child: Text(
                                    "This month’s power consumption",
                                    style: w300_13Poppins(
                                        color: Color(0xff11271D)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        width10,
                        Container(
                          width: 138.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffF8F8F8)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "6",
                                      style: w600_18Poppins(
                                          color: Color(0xffC39C67))),
                                  TextSpan(
                                      text: " UNITS",
                                      style: w400_14Poppins(
                                          color: Colors.black87)),
                                ])),
                                height10,
                                SizedBox(
                                  width: 124.w,
                                  height: 28.h,
                                  child: Text(
                                    "Last month’s power consumption",
                                    style: w300_13Poppins(
                                        color: Color(0xff11271D)),
                                  ),
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
            ),
            DeviceActivityWidget(),
            height10,
            DeviceUsageWidget(progressValue: 0.55, title: "Lights", icon: Icons.lightbulb_outline,isVisible: false,),
            height10,
            DeviceUsageWidget(progressValue: 0.12,title: "Televisions",icon: Icons.tv,isVisible: true,),
            height10,
            DeviceUsageWidget(progressValue: 0.12,title: "Air Conditioners",icon: Icons.ac_unit_outlined,isVisible: false,),
            height10,
            DeviceUsageWidget(progressValue: 0.82,title: "Sensors",icon: Icons.sensor_occupied_outlined,isVisible: true,),
height30,

          ],
        ),
      ),
    );
  }
}

class DeviceActivityWidget extends StatefulWidget {
  const DeviceActivityWidget({super.key});

  @override
  State<DeviceActivityWidget> createState() => _DeviceActivityWidgetState();
}

class _DeviceActivityWidgetState extends State<DeviceActivityWidget> {
  bool isSelected = false;
  final List<String> items = ['Ground Floor', 'First Floor', 'Second Floor'];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20,
        Text(
          "Device Activity (12 Active)",
          style: w500_14Poppins(color: Color(0xff11271D)),
        ),
        height10,
        Row(
          children: [
            Container(
              width: 135.w,
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  hint: Text('Ground Floor'),
                  value: selectedValue,
                  iconStyleData:
                      IconStyleData(iconEnabledColor: Color(0xffC39C67)),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: w500_12Poppins(color: Color(0xff11271D)),
                            ),
                          ))
                      .toList(),
                  buttonStyleData: const ButtonStyleData(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white)),
                ),
              ),
            ),
            width10,
            Container(
              width: 135.w,
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  hint: Text('Living Room'),
                  value: selectedValue,
                  iconStyleData:
                      IconStyleData(iconEnabledColor: Color(0xffC39C67)),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: w500_12Poppins(color: Color(0xff11271D)),
                            ),
                          ))
                      .toList(),
                  buttonStyleData: const ButtonStyleData(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white)),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}


