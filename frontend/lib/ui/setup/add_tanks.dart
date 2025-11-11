import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/ui/common_appbar.dart';
import 'package:utility/ui/setup/select_conditionAction_screen.dart';
import 'package:utility/ui/setup/setup_screen.dart';
import 'package:utility/utils/appColors.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';
class AddTanksScreen extends StatefulWidget {
  AddTanksScreen(
      {super.key,
      this.phoneNumber,
      this.selectedConditionName,
      this.selectedActionDeviceName,
      this.selectedActionParameterName,
       this.progressValue,
      this.selectedConditionParameterName});
  String? phoneNumber;
  String? selectedConditionName;
  String? selectedActionDeviceName;
  String? selectedActionParameterName;
  String? selectedConditionParameterName;
  final double? progressValue;

  @override
  State<AddTanksScreen> createState() => _AddTanksScreenState();
}

class _AddTanksScreenState extends State<AddTanksScreen> {
  List<int> itemCounts = [1]; // List of 10 items

  void addMoreConditionsBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 190.h,
            child: Column(
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
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                    width55,
                    width50,
                    Text(
                      "Select Action",
                      style: w400_14Poppins(color: Color(0xff11271D)),
                    ),
                  ],
                ),
                height20,
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Tanks",
                          style: w500_16Poppins(color: Color(0xff11271D)),
                        ),
                        width10,
                        Icon(
                          Icons.arrow_right,
                          color: Color(0xffC39C67),
                        )
                      ],
                    ),
                  ),
                ),
                height15,
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Subversive",
                          style: w500_16Poppins(color: Color(0xff11271D)),
                        ),
                        width10,
                        Icon(
                          Icons.arrow_right,
                          color: Color(0xffC39C67),
                        )
                      ],
                    ),
                  ),
                ),
                height15,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Valve",
                        style: w500_16Poppins(color: Color(0xff11271D)),
                      ),
                      width10,
                      Icon(
                        Icons.arrow_right,
                        color: Color(0xffC39C67),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

     Color getColorFromValue(double value) {
    double normalized = (value.clamp(0, 10)) / 10;
    return Color.lerp(Colors.red, Colors.green, normalized)!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonProvider>(
      builder: (contex,provider,child) {
        return Scaffold(
          appBar: commonAppBar(context, phoneNumber: provider.userName),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Color(0xff11271D),
                  child: Column(
                    children: [
                      height10,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  height15,
                                  Container(
                                    width: 356.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffF6F2E7)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.selectedConditionName!,
                                                style: w500_16Poppins(
                                                    color: Colors.black),
                                              ),
                                               Visibility(
                                                visible: widget.selectedConditionName == "Tank Module 1",
                                                    child: Container(
                                                        height: 20.h,
                                                        width: 20.w,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.blue),
                                                      ),
                                                  ),
                                               Visibility(
                                                visible: widget.selectedConditionName == "Main Motor 1",
                                                    child: Container(
                                                        height: 20.h,
                                                        width: 24.w,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Colors.white,border: Border.all(color: Appcolors.appColor)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Container(
                                                            height: 8.h,
                                                            width: 8.w,
                                                            decoration: BoxDecoration(shape: BoxShape.circle,color: widget.selectedConditionParameterName=="Off"?Colors.red:Colors.green),
                                                          ),
                                                        ),
                                                      ),
                                                  )
                                                
                                            ],
                                          ),
                                          height5,
                                          Consumer<CommonProvider>(
                                              builder: (context, provider, child) {
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                itemCount: itemCounts.length,
                                                itemBuilder: (context, int) {
                                                  return customCardTank(context,
                                                      provider, itemCounts[int]);
                                                });
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  height5,
                                  Divider(),
                                  height5,
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (contex)=>SelectConditionactionScreen()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Color(0xffC39C67)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              color: Colors.white,
                                            ),
                                            width10,
                                            Text(
                                              "Add more conditions",
                                              style: w500_16Poppins(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Padding customCardTank(
      BuildContext context, CommonProvider provider, int itemId) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: ListTile(
          onTap: () {
            Navigator.push( 
                context,
                MaterialPageRoute(
                    builder: (context) => SetupScreen(
                        )));
          },
          title: Text(
            'Base Module 1',
            style: w500_14Poppins(color: Colors.black),
          ),
          subtitle: Text(
            widget.selectedActionDeviceName!,
            style: w400_15Poppins(color: Colors.black),
          ),
          trailing: Text(
            widget.selectedActionParameterName!,
            style: w500_14Poppins(color:widget.selectedActionParameterName=="On"?Colors.green:Colors.red ),
          ),
          tileColor: Colors.grey[100],
        ),
      ),
    );
  }
}
