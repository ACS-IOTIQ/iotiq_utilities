import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility/auth/phone_loginScreen.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: 50.h),
                SvgPicture.asset(AppImages.logo),
                SizedBox(height: 40.h),

                // This takes all remaining space
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(200.r),
                        topRight: Radius.circular(200.r),
                      ),
                      border: Border.all(color: Colors.black45),
                      image: DecorationImage(
                        image: AssetImage(AppImages.landingImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        SvgPicture.asset(AppImages.smartLuxury),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            "Step into a world of unparalleled convenience and elevate your living experience",
                            style: w400_14Poppins(color: const Color(0xffC39C67)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) =>  PhoneLoginUi()),
                            );
                          },
                          child: Container(
                            height: 40.h,
                            width: 290.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppImages.mobileIcon),
                                SizedBox(width: 5.w),
                                Text(
                                  "Continue with Phone",
                                  style: w500_14Poppins(color: const Color(0xff11271D)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
