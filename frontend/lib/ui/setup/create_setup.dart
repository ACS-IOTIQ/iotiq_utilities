import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility/ui/setup/select_conditionAction_screen.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';

class CreateSetupScreen extends StatefulWidget {
  const CreateSetupScreen({super.key});

  @override
  State<CreateSetupScreen> createState() => CreateSetupScreenState();
}

class CreateSetupScreenState extends State<CreateSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*1,
        child: Column(
          children: [
            height70,
            height70,
            height15,

            CircleAvatar(
              radius: 65,
              backgroundColor: Color(0xffC39C67),
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                backgroundColor: Colors.white,
                  
                  radius: 36,child: SvgPicture.asset(AppImages.deviceSetup,color: Color(0xffC39C67),height: 70,width: 70,),)),
            ),
            height20,
            SizedBox(
              width: 250.w,
              height: 50.h,
              child: Text("No Setup created for the selected Space so far. Create a setup to automate your appliances",style: w400_16Poppins(color: Color(0xff828282)),textAlign: TextAlign.center,),
            ),
            height20,
            CustomButton(
              height: 45,
              width: 200,
              borderRadius: 18,
              onTap: (){
                // customShowDialog(context, SetupBottomsheet());
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectConditionactionScreen()));
              },
              buttonText: "Create Setup",textColor: Colors.white,buttonColor: Color(0xffC39C67),)
           
          ],
        ),
      
    );
  }
}