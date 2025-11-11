import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';

class SetupspaceBottomsheet extends StatefulWidget {
  const SetupspaceBottomsheet({super.key});

  @override
  State<SetupspaceBottomsheet> createState() => _SetupspaceBottomsheetState();
}

class _SetupspaceBottomsheetState extends State<SetupspaceBottomsheet> {
  final _formSpaceKey = GlobalKey<FormState>();
late SpacesProvider spacesProvider;
  final TextEditingController spaceNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(listen: false,context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    spaceNameController.dispose();
    addressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SpacesProvider>(
      builder: (context,spaceProvider,child) {
        return Form(
          key: _formSpaceKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                Text( "Let's name your home",
                        style: w500_16Poppins(color: Color(0xff11271D)),),
                        height20,
                         Container(
                        width: 339.w,
                      
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12)),
                        child: Column(
                          children: [
                              TextFormField(
                            controller: spaceNameController,
                            style: w400_14Poppins(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Space name',
                                  hintStyle: w400_14Poppins(color: Colors.grey.shade500),
            
                              border: InputBorder.none, // No border
                              filled: true,
                              fillColor: Colors.white,
                              // Background color
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Space name is required';
                              } 
                              return null;
                            },
                          ),
                          Divider(),
                           TextFormField(
                            controller: addressController,
                            style: w400_14Poppins(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Address',
                                  hintStyle: w400_14Poppins(color: Colors.grey.shade500),
            
                              border: InputBorder.none, // No border
                              filled: true,
                              fillColor: Colors.white,
                              // Background color
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Address is required';
                              } 
                              return null;
                            },
                          ),
                ],
                        ),
                      ),
                height15,
                CustomButton(
                  onTap: (){
                    if  (_formSpaceKey.currentState!.validate()){
                      FocusScope.of(context).unfocus();
            
                    spaceProvider.createSpace(spaceName: spaceNameController.text, address: addressController.text,context: context);
                    }
               
                  },
                  buttonText: "Continue",width: 333.w,borderRadius: 20,
                  buttonColor: Appcolors.appColor,
                  ),
               
              
              ],
            ),
          ),
        );
      }
    );
  }
}