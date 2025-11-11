import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/ui/setup/add_tanks.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';


class SetupBottomsheet extends StatefulWidget {
  const SetupBottomsheet({super.key});

  @override
  State<SetupBottomsheet> createState() => _SetupBottomsheetState();
}

class _SetupBottomsheetState extends State<SetupBottomsheet> {
   late CommonProvider commonProvider;

  @override
  void initState() {
    // TODO: implement initState
    commonProvider = Provider.of<CommonProvider>(listen: false,context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CommonProvider>(
    builder: (context,provider,child) {
      return  Container(
          
          height: 190.h,
          child: Column(
            children: [
              height10,
           Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 50.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xffEBEBEB)),
                  ),
                ),
                height20,
                Text("Select Condition",style: w400_14Poppins(color: Color(0xff11271D)),),
                height20,
              InkWell(
                onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTanksScreen(phoneNumber: provider.phoneController.text,)));
        
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                
                    children: [
                      Text("Tanks",style: w500_16Poppins(color: Color(0xff11271D)),),
                      width10,
                
                      Icon(Icons.arrow_right,color: Color(0xffC39C67),)
                    ],
                  ),
                ),
              ),
              height15,
               InkWell(
                onTap: (){
                },
                 child: SizedBox(
                  width: MediaQuery.of(context).size.width*1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Subversive",style: w500_16Poppins(color: Color(0xff11271D)),),
                      width10,
                 
                      Icon(Icons.arrow_right,color: Color(0xffC39C67),)
                    ],
                  ),
                           ),
               ),
              height15,
               SizedBox(
                width: MediaQuery.of(context).size.width*1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
        
                  children: [
                    Text("Valve",style: w500_16Poppins(color: Color(0xff11271D)),),
                    width10,
                    Icon(Icons.arrow_right,color: Color(0xffC39C67),)
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}


class selectActionBottomSheet extends StatefulWidget {
  const selectActionBottomSheet({super.key});

  @override
  State<selectActionBottomSheet> createState() => _selectActionBottomSheetState();
}

class _selectActionBottomSheetState extends State<selectActionBottomSheet> {
  late CommonProvider commonProvider;

  @override
  void initState() {
    // TODO: implement initState
    commonProvider = Provider.of<CommonProvider>(listen: false,context);
    super.initState();
  }
@override
  Widget build(BuildContext context){
  return Consumer<CommonProvider>(
    builder: (context,provider,child) {
      return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
            children: [
              height10,
           Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 50.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xffEBEBEB)),
                  ),
                ),
                height10,
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                      width55,
                      width50,
                    Text("Select Action",style: w400_14Poppins(color: Color(0xff11271D)),),
                  ],
                ),
                height20,
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTanksScreen(phoneNumber: provider.phoneController.text,)));
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                
                    children: [
                      Text("Tanks",style: w500_16Poppins(color: Color(0xff11271D)),),
                      width10,
                
                      Icon(Icons.arrow_right,color: Color(0xffC39C67),)
                    ],
                  ),
                ),
              ),
              height15,
               InkWell(
                onTap: (){
                },
                 child: SizedBox(
                  width: MediaQuery.of(context).size.width*1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Subversive",style: w500_16Poppins(color: Color(0xff11271D)),),
                      width10,
                 
                      Icon(Icons.arrow_right,color: Color(0xffC39C67),)
                    ],
                  ),
                           ),
               ),
              height15,
               SizedBox(
                width: MediaQuery.of(context).size.width*1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
      
                  children: [
                    Text("Valve",style: w500_16Poppins(color: Color(0xff11271D)),),
                    width10,
                    Icon(Icons.arrow_right,color: Color(0xffC39C67),)
                  ],
                ),
              )
            ],
          ),
        );
    }
  );
}
}