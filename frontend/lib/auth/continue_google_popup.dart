import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';


class ContinueWithGooglePopUp extends StatelessWidget {
  const ContinueWithGooglePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Row(
          children: [
            SvgPicture.asset(AppImages.googleIcon),
            width5,
            Text("Sign In With Google",style: w400_14Poppins(),)
          ],
        ),
        Divider(),
        height50,

        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Color(0xff11271D)),
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: SvgPicture.asset(AppImages.appLogoOrange),
           ),
        ),
        height20,
        Text("Choose an account",style: w400_24Poppins(),),
        Text("to continue to IOTIQ",style: w400_16Poppins(),),
        height40,
        SizedBox(
          width: 360.w,
          height: 40.h,
child: Row(
  children: [
    width30,
    Container(
      height: 32.h,
      width: 32.w,
decoration: BoxDecoration(shape: BoxShape.circle,
color: Colors.blueAccent
),
    ),
    width20,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height5,
        Text("hello Everyone",style: w500_14Poppins(),),
        Text("helloeveryone@gmail.cpm",style: w400_12Poppins(),)
      ],
    )
  ],
),
        ),
        Divider(),
         SizedBox(
          width: 360.w,
          height: 40.h,

child: Row(
  children: [
    width30,
    Container(
      height: 32,
      width: 32,
decoration: BoxDecoration(shape: BoxShape.circle,
color: Colors.blueAccent
),
    ),
    width20,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height5,
        Text("hello Everyone",style: w500_14Poppins(),),
        Text("helloeveryone@gmail.cpm",style: w400_12Poppins(),)
      ],
    )
  ],
),
        ),
        Divider(),
        SizedBox(
          width: 360,
          height: 50,
child: Row(
  children: [
    width30,
    Container(
     
decoration: BoxDecoration(shape: BoxShape.circle,

),
child: Icon(Icons.person_pin_circle_outlined),
    ),
    width20,
   Text("Choose another account",style: w500_14Poppins(),)
  ],
),
        ),
        Divider(),
        height30,
         SizedBox(

          width: 270,
          height: 105,
           child: Wrap(
            children: [
              Text(
                '''To continue, Google will share your name, email address, language preference, and profile picture with Company. Before using this app, you can review ''',
                style: w400_14Poppins(color: Color(0xff11271D)),
              ),
               GestureDetector(
                onTap: () {
                },
                child: Text('''Privacy Policy''', style: w500_14Poppins(color:  Colors.blue)),
              ),
              Text(''' and ''', style: w400_14Poppins(color: Color(0xff11271D))),

              GestureDetector(
                onTap: () {
                },
                child: Text(
                  ''' Terms & Conditions ''',
                  style: w500_14Poppins(color: Colors.blue),
                ),
              ),
             
            ],
                   ),
         ),
      
        
        ],
      ),
      actions: [
      
        height10
      ],
    );
  }
}


