import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/get_all_setupDevices_model.dart';
import 'package:utility/model/spaces/get_all_spaces.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/ui/setup/select_conditionAction_screen.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';
class ManageSetups extends StatefulWidget {
  const ManageSetups({super.key});

  @override
  State<ManageSetups> createState() => _ManageSetupsState();
}

class _ManageSetupsState extends State<ManageSetups> with SingleTickerProviderStateMixin{
  bool isLoading = false;
  // List<GetAllSpacesDataModel>? spaces;
  GetAllSetupDevicesModel? setupDevices;
  // List of 10 items
  late SpacesProvider spacesProvider;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);

    // String selectedSpaceId =
    //     spacesProvider.selectedSpaceId ??
    //     "default_space_id"; // Replace as needed
    spacesProvider.fetchSetupDevices(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:  Colors.white,
          leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
           title:  Text("Manage Setups",
            style: w400_16Poppins(),),
          centerTitle: true,
          elevation: 0,
        ),
        body:
         Consumer2<SpacesProvider,CommonProvider>(
      builder: (context,spaceProvider,provider,child) {
            return  Container(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  spaceProvider.setupDevices == null ||
                      spaceProvider.setupDevices!.data!.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        children: [
                          height70,
                          height70,
                          height15,

                          CircleAvatar(
                            radius: 65,
                            backgroundColor: const Color(0xffC39C67),
                            child: CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,

                                radius: 36,
                                child: SvgPicture.asset(
                                  AppImages.deviceSetup,
                                  color: const Color(0xffC39C67),
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            ),
                          ),
                          height20,
                          SizedBox(
                            width: 250.w,
                            height: 50.h,
                            child: Text(
                              "No Setups are created so far. Create a setup to automate your appliances",
                              style: w400_16Poppins(
                                color: const Color(0xff828282),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          height20,
                          
                        ],
                      ),
                    )
                  : 
                       ListView.builder(
                                    itemCount: spaceProvider.setupDevices!.data!.length,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        onTap: (){
                                          spaceProvider.fetchDevices(provider.userId,context);
                                        },
                                        child: Card(
                                              margin: EdgeInsets.only(bottom: 16),
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  side: BorderSide(color: Colors.grey.shade300)),
                                              elevation: 0,
                                              child: Padding(
                                                padding: EdgeInsets.all(12),
                                                child:
                                                
                                                 Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                     onTap: (){
                                                     
                                                     },
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                           "assets/icons/Frame.svg",
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
                                                             Text(
                                                      spaceProvider
                                                                  .setupDevices!
                                                                  .data![index]
                                                                  .condition!
                                                                  .switchNo ==
                                                              null



                                                
                                                          ? spaceProvider
                                                                .setupDevices!
                                                                .data![index]
                                                                .condition!
                                                                .deviceName!
                                                          : "${spaceProvider.setupDevices!.data![index].condition!.deviceName!} - ${spaceProvider.setupDevices!.data![index].condition!.switchNo!}",
                                                      style: w500_16Poppins(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                            
                                                            ],
                                                          )),
                                                           InkWell(
                                                          onTap: (){
                                                            deleteSpace(index,context,spaceProvider.setupDevices!.data![index].condition!.deviceName!,spaceProvider.setupDevices!.data![index].id!);
                                                          },
                                                            child: Icon(
                                                                                                                    Icons.delete_outline,color: Colors.red,     ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  
                                                  ],
                                                ),
                                              ),
                                            ),
                                      );
                                    })
                    // }
                  // ),
                ));
          }
        ),
        bottomNavigationBar: Consumer<CommonProvider>(
          builder: (context,commonProvider,child) {
            return Padding(padding: EdgeInsets.only(bottom: 20),
              child:
             Container(
                  height: 58.h,
                 color: Colors.white,
                   padding:const EdgeInsets.all(16),
                  child: ElevatedButton.icon(onPressed: (){
            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectConditionactionScreen(),
                                ),
                              );   },
              icon:const Icon(Icons.add,color: Color(0xffC39C67),),
              label: Text("Add New Setup",
                style: w500_14Poppins(color: Colors.black)) ,
              style: ElevatedButton.styleFrom(
                  backgroundColor:Color.fromARGB(255, 237, 228, 203),
                  elevation:0,
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20,
                    ),
            
                  ))
                  ),
                ));
          }
        )

    );

  }
  void deleteSpace(int index,BuildContext context,String title,String id) {
     showModalBottomSheet(
      backgroundColor: Color(0xffFBFAF5),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
       builder: (BuildContext context) {
        return  Consumer<SpacesProvider>(
          builder: (context,spacePrrovider,child) {
            return Column(
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
               
                Column(
                  children: [
                      SizedBox(
                      width: 310.w,
                      height: 60.h,
                      child: Text("Are you sure you want to remove the Setup ${title}?",style: w400_15Poppins(),)),
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
                          spacePrrovider.deleteSetup(id,context).then((value){
                            
spacePrrovider.fetchSetupDevices(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Homescreen(startIndex: 0,phoneNumber: Provider.of<CommonProvider>(listen:false,context).userName,)));

                          });
                        Navigator.pop(context);
                      },)
                    ],
                  )
                  ],
                ),
            
                height10,
              ],
            );
          }
        );}
     );
  }

  // void editSpace(int index, BuildContext context,String title,String address,String id) {
  //   TextEditingController nameController =
  //       TextEditingController();
  //   TextEditingController addressController =
  //       TextEditingController();

  //   showModalBottomSheet(
  //     backgroundColor: Color(0xffFBFAF5),
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (BuildContext context) {
  //       nameController.text = title;
  //       addressController.text = address;
  //       return Consumer<SpacesProvider>(
  //         builder: (context,spacePrrovider,child) {
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 height10,
  //                 Align(
  //                   alignment: Alignment.center,
  //                   child: Container(
  //                     height: 5.h,
  //                     width: 50.w,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(20),
  //                         color: const Color(0xffEBEBEB)),
  //                   ),
  //                 ),
  //                 height10,
  //                 Text(
  //                   "Edit space",
  //                   style: w500_16Poppins(color: Color(0xff11271D)),
  //                 ),
  //                 height15,
  //                 Container(
  //                   width: 339.w,
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: Colors.black12)),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       children: [
  //                         TextField(
  //                           controller: nameController,
  //                           style: w400_14Poppins(color: Colors.black),

  //                           decoration: InputDecoration(border: InputBorder.none),
  //                         ),
  //                         Divider(),
  //                         TextField(
  //                           controller: addressController,
  //                           style: w400_14Poppins(color: Colors.black),

  //                           decoration: InputDecoration(border: InputBorder.none),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 height15,
  //                 CustomButton(
  //                   width: 330.w,
  //                   buttonColor: Appcolors.appColor,
  //                   borderRadius: 20,
  //                   buttonText: "Save",
  //                   onTap: () {
  //                     spacePrrovider.updateSpace(id,nameController.text,addressController.text,context).then((value){
  //                     Navigator.push(context, MaterialPageRoute(builder: (context)=> Homescreen(startIndex: 0,phoneNumber: Provider.of<CommonProvider>(listen:false,context).userName,)));

  //                     });
                     
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //                 SizedBox(height: 16),
  //               ],
  //             ),
  //           );
  //         }
  //       );
  //     },
  //   );
  // }
}
