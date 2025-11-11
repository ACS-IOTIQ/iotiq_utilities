import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility/auth/landing_screen.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/utils/images.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late SpacesProvider spacesProvider;
  @override
  void initState() {
    nextFunction(context);
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);
    super.initState();
  }

  void nextFunction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token"); // ✅ use correct key
    String? userName = prefs.getString("user_name");
    // Optional delay to simulate splash
    await Future.delayed(const Duration(seconds: 2));
    if (token != null && token.trim().isNotEmpty) {
      spacesProvider.initializeDefaultSpace(context);
      Future.delayed(const Duration(seconds: 1), () async {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Homescreen(startIndex: 1, phoneNumber: userName),
          ),
        );
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11271D),
      body: Center(
        child: Lottie.asset(AppImages.splashImage, width: 100.w, height: 100.h),
      ),
    );
  }
}
 
