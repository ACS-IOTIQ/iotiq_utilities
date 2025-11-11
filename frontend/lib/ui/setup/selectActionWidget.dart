import 'package:flutter/material.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class Selectactionwidget extends StatefulWidget {
  const Selectactionwidget({super.key});
  

  @override
  State<Selectactionwidget> createState() => _SelectactionwidgetState();
}

class _SelectactionwidgetState extends State<Selectactionwidget> {
   String selectedDeviceName = "Select Device";
  final List<String> items = ['Main Motor', 'Centrifugal Motor', 'Value Main'];
  void selectActionDeviceBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true, // This allows the BottomSheet to adjust height based on content
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              height10,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffEBEBEB),
                  ),
                ),
              ),
              height10,
              Text(
                "Select Action Device",
                style: w400_14Poppins(),
              ),
              height15,
              ListView.builder(
                shrinkWrap: true, // Ensures the ListView only takes the necessary space
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                      
                        Text(items[index],style: w500_14Poppins(),textAlign: TextAlign.end,),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      setState(() {
                        selectedDeviceName = items[index];
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

   String selectedParameterName = "Select Action Parameter";
  final List<String> parameterItems = ["On","Off"];
  void selectParameterBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true, // This allows the BottomSheet to adjust height based on content
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              height10,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffEBEBEB),
                  ),
                ),
              ),
              height10,
              Text(
                "Select Action Parameter",
                style: w400_14Poppins(),
              ),
              height15,
              ListView.builder(
                shrinkWrap: true, // Ensures the ListView only takes the necessary space
                itemCount: parameterItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                      
                        Text(parameterItems[index],style: w500_14Poppins(),textAlign: TextAlign.end,),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      setState(() {
                        selectedParameterName = items[index];
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xffF5F1E5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height5,
                      Text(
                        "Action",
                        style: w400_14Poppins(color: Colors.black),
                      ),
                      height10,
                      InkWell(
                        onTap: () {
                          selectActionDeviceBottomSheet();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDeviceName,
                                  style: w400_14Poppins(color: Appcolors.textColor),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Appcolors.appColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                       height10,
                      InkWell(
                        onTap: () {
                        selectParameterBottomSheet();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                        selectedParameterName,
                                  style: w400_14Poppins(color: Appcolors.textColor),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Appcolors.appColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}