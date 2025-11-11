import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/auth/phone_loginScreen.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Sign Up Form",
          style: w500_15Poppins(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(AppImages.appLogoOrange),
          )
        ],
      ),
      body: Consumer<CommonProvider>(builder: (context, provider, child) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                height15,
                Container(
                  width: 339.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: provider.nameController,
                       
                        keyboardType: TextInputType.name,
                        style: w400_14Poppins(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Name*',

                          hintStyle: w400_14Poppins(color: Colors.grey.shade500),
                          border: InputBorder.none, // No border
                          filled: true,
                          fillColor: Colors.white,
                          // Background color
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } 
                          return null;
                        },
                      ),
                      Divider(color: Colors.black12),
                     TextFormField(
                        controller: provider.phoneSignUpController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              10), // Limit input to 10 digits
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits
                        ],
                        keyboardType: TextInputType.phone,
                        style: w400_14Poppins(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Phone Number*',
                          hintStyle: w400_14Poppins(color: Colors.grey.shade500),

                          border: InputBorder.none, // No border
                          filled: true,
                          fillColor: Colors.white,
                          // Background color
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } 
                          return null;
                        },
                      ),
                  
                    ],
                  ),
                ),
                height5,
                      TermsAndConditions(text: "signing up",),
                      Spacer(),
                      SizedBox(
                      height: 35.h,
                      width: 350.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Appcolors.appColor),
                        onPressed:(){
                          provider.signUp(provider.phoneSignUpController.text, provider.nameController.text,context);
                        },
                        child: Text('Verify',style: w500_14Poppins(color: Colors.white),),
                      ),
                    ),
                    height10,

              ],
            ));
      }),
    );
  }
}
