import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility/ui/common_appbar.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';


class SetupAutomation extends StatefulWidget {
  String? phoneNumber;
   SetupAutomation({super.key,this.phoneNumber});

  @override
  State<SetupAutomation> createState() => _SetupAutomationState();
}

class _SetupAutomationState extends State<SetupAutomation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: commonAppBar(context,phoneNumber: widget.phoneNumber),
            body: Container(
        color: Color(0xff11271D),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back)),
                            Text("Setup 1",style: w500_18Poppins(color: Color(0xff11271D)),)
                        ],
                      ),
                      height40,
                    SvgPicture.asset(AppImages.setupDetails)
                    ],
                  ),
                ),
                ))
    ));
  }
}