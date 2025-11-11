// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';

class SpaceCard extends StatefulWidget {
  SpaceCard(
      {super.key, 
      required this.title,
      required this.location,
      required this.isSelected,
      required this.index,
      required this.type,
      required this.iconPath,
      required this.onTap});
  String title;
  final String type;
  String location;
  final String iconPath;
  final VoidCallback onTap;
  final bool isSelected;
  final int index;

  @override
  State<SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends State<SpaceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onTap,
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.iconPath,
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              TextSpan(
                                  text: "${widget.type}:",
                                  style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                  text: widget.title,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.location,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
                  Icon(
                    widget.isSelected
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: widget.isSelected ? Color(0xffC39C67) : Colors.grey,
                  )
                ],
              ),
            ),
            Divider(height: 20, color: Colors.grey.shade300),
            Row(
              children: [
                width30,
                InkWell(
                    onTap: () {
                      editSpace(widget.index, context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Color(0xffC39C67),
                        ),
                        width10,
                        Text(
                          "Edit Space",
                          style: w500_14Poppins(),
                        ),
                      ],
                    )),
                width15,
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    width: 1,
                    color: Colors.grey.shade300),
                width15,
                InkWell(
                  onTap: (){
                    deleteSpace(widget.index, context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                         width10,
                  Text(
                    "Delete space",
                    style: w600_14Poppins(color: Colors.black),
                  )
                    ],
                  ),
                ),
             
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteSpace(int index, BuildContext context) {
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
            widget.isSelected?Column(
              children: [
                SizedBox(
                  width: 310.w,
                  height: 60.h,
                  child: Text("You cannot remove the space you are currently in. Please change to a different space before deleting this space.",style: w400_15Poppins(),)),
              
               CustomButton(
          width: 330.w,
              buttonColor: Appcolors.appColor,
              borderRadius: 20,
              buttonText: "Close",
              onTap: () {
                
                Navigator.pop(context);
              },
            ),],
            ):Column(
              children: [
                  SizedBox(
                  width: 310.w,
                  height: 60.h,
                  child: Text("Are you sure you want to remove the Space ${widget.title}?",style: w400_15Poppins(),)),
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
                    buttonText: "Yes, Remove",onTap: (){
                    Navigator.pop(context);
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

  void editSpace(int index, BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.title);
    TextEditingController addressController =
        TextEditingController(text: widget.location);

    showModalBottomSheet(
      backgroundColor: Color(0xffFBFAF5),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
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
              Text(
                "Edit space",
                style: w500_16Poppins(color: Color(0xff11271D)),
              ),
              height15,
              Container(
                width: 339.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                      Divider(),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ],
                  ),
                ),
              ),
              height15,
              CustomButton(
                buttonColor: Appcolors.appColor,
                borderRadius: 20,
                buttonText: "Save",
                onTap: () {
                  setState(() {
                    widget.title = nameController.text;
                    widget.location = addressController.text;
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
