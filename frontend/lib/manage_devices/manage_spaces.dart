import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/spaces/get_all_spaces.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';
class ManageSpaces extends StatefulWidget {
  const ManageSpaces({super.key});

  @override
  State<ManageSpaces> createState() => _ManageSpacesState();
}

class _ManageSpacesState extends State<ManageSpaces> {
  int? selectedIndex=0;
  bool isLoading = false;
  List<GetAllSpacesDataModel>? spaces;
//   final List<Map<String, String>> spaces =[
//     {
//       "title": " Mannat Villa",
//       "location": "TNGO's,Gachhibowli,Hyderabad",
//       "type": "Home ","icon": "assets/icons/Frame.svg",
//     },
//     {
//       "title": " IOTIQ Staff Quarter",
//       "location":"TNGO's,Gachhibowli,Hyderabad" ,
//       "type": "office ",
//       "icon": "assets/icons/XMLID_613_.svg"
//     },
//     {
//       "title": " IOTIQ HQ",
//       "location": "TNGO's,Gachhibowli,Hyderabad",
//       "type": "office ",
//       "icon": "assets/icons/XMLID_635_.svg",
//     }
//   ];
late SpacesProvider spacesProvider;

  Future<void> _loadSpaces() async {
    try {
      final response = await spacesProvider.fetchSpaces(context);
      setState(() {
        spaces = response?.data ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        spaces = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(listen: false,context);
  _loadSpaces();
    
  }

    void updateSelectedIndex(List<GetAllSpacesDataModel> spaces) {
    final selectedId = selectedIndex;
    if (selectedId != null) {
      final index = spaces.indexWhere((space) => space.id == selectedId);
      if (index != -1) {
        setState(() {
          selectedIndex = index;
        });
      }
    }
  }

   Future<void> _deleteSpace(String id) async {
    await Provider.of<SpacesProvider>(context, listen: false).deleteSpace(id,context);
    // Optionally, refresh the list after deletion
    await Provider.of<SpacesProvider>(context, listen: false).fetchSpaces(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:  Colors.white,
          leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
           title:  Text("Manage Spaces",
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
                  child:FutureBuilder<GetAllSpacesModel?>(
        future: spaceProvider.fetchSpaces(context),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Failed to load spaces.',style: w400_15Poppins(color: Colors.black),));
          }
          if(snapshot.data!.data.isEmpty){
            return Center(child: Text('Data not found',style: w400_15Poppins(color: Colors.black),));
          } 
            final List<GetAllSpacesDataModel> spaces = snapshot.data!.data;

                    // 💡 Set selected index once data is loaded
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (selectedIndex == null) {
                        updateSelectedIndex(spaces);
                      }
                    });
                      return ListView.builder(
                                    itemCount: spaces.length,
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
                                                      setState(() {
                                                        selectedIndex = index;
                                                      });
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
                                                              RichText(
                                                                text: TextSpan(
                                                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                                                    children: [
                                                                      TextSpan(
                                                                          text: "Home:",
                                                                          style: TextStyle(
                                                                            color: Colors.brown,
                                                                            fontWeight: FontWeight.bold,
                                                                          )),
                                                                      TextSpan(
                                                                          text: spaces[index].spaceName,
                                                                          style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                                                    ]),
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                spaces[index].address,
                                                                style: TextStyle(color: Colors.grey),
                                                              )
                                                            ],
                                                          )),
                                                          Icon(
                                                            selectedIndex == index
                                                                ? Icons.check_circle
                                                                : Icons.circle_outlined,
                                                            color: selectedIndex ==index ? Color(0xffC39C67) : Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(height: 20, color: Colors.grey.shade300),
                                                    Row(
                                                      children: [
                                                        width20,
                                                        InkWell(
                                                            onTap: () {
                                                              editSpace(index, context,spaces[index].spaceName,spaces[index].address,spaces[index].id);
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
                                                            deleteSpace(index, context,spaces[index].spaceName,spaces[index].id,selectedIndex!);
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
                                            ),
                                      );
                                    });
                    }
                  ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen(startIndex: 0,showBottomSheet: true,phoneNumber: commonProvider.userName ,)));
                  },
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
                ));
          }
        )

    );

  }
  void deleteSpace(int index, BuildContext context,String title,String id,int isSelected) {
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
                isSelected == index?Column(
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
                ):
                Column(
                  children: [
                      SizedBox(
                      width: 310.w,
                      height: 60.h,
                      child: Text("Are you sure you want to remove the Space ${title}?",style: w400_15Poppins(),)),
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
                          spacePrrovider.deleteSpace(id,context).then((value){
                            _deleteSpace(id);
spacePrrovider.fetchSpaces(context);
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

  void editSpace(int index, BuildContext context,String title,String address,String id) {
    TextEditingController nameController =
        TextEditingController();
    TextEditingController addressController =
        TextEditingController();

    showModalBottomSheet(
      backgroundColor: Color(0xffFBFAF5),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        nameController.text = title;
        addressController.text = address;
        return Consumer<SpacesProvider>(
          builder: (context,spacePrrovider,child) {
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
                            style: w400_14Poppins(color: Colors.black),

                            decoration: InputDecoration(border: InputBorder.none),
                          ),
                          Divider(),
                          TextField(
                            controller: addressController,
                            style: w400_14Poppins(color: Colors.black),

                            decoration: InputDecoration(border: InputBorder.none),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height15,
                  CustomButton(
                    width: 330.w,
                    buttonColor: Appcolors.appColor,
                    borderRadius: 20,
                    buttonText: "Save",
                    onTap: () {
                      spacePrrovider.updateSpace(id,nameController.text,addressController.text,context).then((value){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Homescreen(startIndex: 0,phoneNumber: Provider.of<CommonProvider>(listen:false,context).userName,)));

                      });
                     
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          }
        );
      },
    );
  }
}
