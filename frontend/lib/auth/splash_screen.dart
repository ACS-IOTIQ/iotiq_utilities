import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility/auth/landing_screen.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late CommonProvider commonProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commonProvider = Provider.of<CommonProvider>(context, listen: false);
    Future.delayed(Duration(seconds: 2),()async{
   await Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LandingScreen()), (route) => false, );
       
    });
  //    WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await loadAccessToken();
  //     checkLoginStatus();
  // });
  }

  Future<void> loadAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
final userName = prefs.getString('userName');
  final commonProvider = Provider.of<CommonProvider>(context, listen: false);
  commonProvider.setAccessToken(token!);
  commonProvider.setUserName(userName);// Update your provider with stored token
}

// void checkLoginStatus() async {
//   final commonProvider = Provider.of<CommonProvider>(context, listen: false);
//   final token = commonProvider.accessToken;
//   final userName = commonProvider.userName;
//   print("Token: $token");
//   print("Username: $userName");
//   if (token == null || token.isEmpty || userName == null || userName.isEmpty) {
//     Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LandingScreen()), (route) => false, );
//   } else {
//     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Homescreen(startIndex: 0,phoneNumber: userName,),),);}
// }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff11271D),
      body: Center(
  child: Lottie.asset(
    AppImages.splashImage,
    width: 100.w,
    height: 100.h
    
  ),
),

    );
  }
}