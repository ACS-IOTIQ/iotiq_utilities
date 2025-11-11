import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utility/utils/app_fonts.dart';
class AddNewButton extends StatefulWidget {
  const AddNewButton({super.key});

  @override
  State<AddNewButton> createState() => _AddNewButtonState();
}

class _AddNewButtonState extends State<AddNewButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      
     color: Colors.white,
       padding:const EdgeInsets.all(16),
      child: ElevatedButton.icon(onPressed: (){},
          icon:const Icon(Icons.add,color: Color(0xffC39C67),),
          label: Text("Add New Space",
            style: w500_14Poppins(color: Colors.black)) ,
          style: ElevatedButton.styleFrom(
              backgroundColor:Color.fromARGB(255, 237, 228, 203),

              
              elevation:0,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20,
                ),

              ))
      ),
    );
  }
}