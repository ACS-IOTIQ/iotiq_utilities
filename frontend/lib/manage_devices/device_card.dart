import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';
class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key,
    required this.brand,
    required this.iconPath,
    required this.name,});
  final  IconData iconPath ;
  final String name;
  final String brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffC39C67)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(name,
               overflow: TextOverflow.ellipsis,
                        style: w400_16Poppins(color: Colors.black)),
                      height5,
                      Text(brand,
                        style:w300_13Poppins(color: Colors.black)),
           
            ],
          ),
                  Icon(iconPath,color: Color(0xffC39C67),),

        ],
      ),
    );


  }
}

