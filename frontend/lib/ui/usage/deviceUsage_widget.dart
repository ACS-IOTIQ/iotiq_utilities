import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class DeviceUsageWidget extends StatefulWidget {
   DeviceUsageWidget({
    super.key,
    required this.progressValue,
    required this.title,
    required this.icon,
    required this.isVisible
  });

  final double progressValue;
  final String title;
  final IconData icon;
  final bool isVisible;

  @override
  State<DeviceUsageWidget> createState() => _DeviceUsageWidgetState();
}

class _DeviceUsageWidgetState extends State<DeviceUsageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 90.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: [
                  Icon(widget.icon,color: Color(0xffc39c67),),
                   width5,
              Text(widget.title,style: w500_14Poppins(color: Color(0xff11217d)),),
              width10,
              widget.isVisible == true
              ? Container(
                height: 12.h,
                width: 18.w,
                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.red),
              ):SizedBox()
                ],
              ),
             
               Row(
                 children: [
                   RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "6",style: w600_18Poppins(color: Color(0xffC39C67))),
                                TextSpan(text: " UNITS",style: w400_14Poppins(color: Colors.black87)),
                              ]
                            )),
                            width10,
                        SvgPicture.asset(AppImages.increaseDecrease)

                 ],
               ),
            ],),
            height20,
            Stack(
              children: [
                LinearProgressIndicator(
                  stopIndicatorColor: Colors.red,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(8),
                  value: widget.progressValue, // 0.0 to 1.0
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff11217D)),
                ),
                Positioned(
                  right: 10,
                  child:             Text('${(widget.progressValue * 100).toInt()}%',style: w400_10Poppins(color: Color(0xff11217D)),),
    )
              ],
            ),
    
    
    
          ],
        ),
      ),
    );
  }
}