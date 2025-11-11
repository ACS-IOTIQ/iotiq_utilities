// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:utility/auth/phoneOtpScreen.dart';
import 'package:utility/auth/signup_screen.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_toast.dart';
import 'package:utility/utils/images.dart';
class PhoneLoginUi extends StatefulWidget {
  const PhoneLoginUi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneLoginUiState createState() => _PhoneLoginUiState();
}

class _PhoneLoginUiState extends State<PhoneLoginUi> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController phoneController = TextEditingController();
  bool isButtonEnabled = true;
  late CommonProvider commonProvider;

  // Update the button state when text changes
  void _onTextChanged() {
    setState(() {
      // _isButtonEnabled = phoneController.text.isNotEmpty; // Check if the text is not empty
    });
  }

  @override
  void dispose() {
    commonProvider.phoneController.removeListener(
        _onTextChanged); // Remove the listener when the widget is disposed
    super.dispose();
    // commonProvider.phoneController.dispose();
  }


  @override
  void initState() {
    super.initState();
    commonProvider = Provider.of<CommonProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Enter your phone number",
          style: w400_14Poppins(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(AppImages.appLogoOrange),
          )
        ],
      ),
      body: Consumer<CommonProvider>(builder: (context, provider, child) {  
        return Form(
          key: _formKey,
          child: Column(
            children: [
              height10,
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Row(
                      children: [
                width15,
                        Container(
                          width: 50.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
                    border: Border.all(color: Colors.black12)),
                          child:Center(child: Text("(+91)",style:w500_14Poppins(color: Colors.black))) ),
                        Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width*0.78,
                          decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12)),
                    border: Border.all(color: Colors.black12)),
                          child: TextFormField(
                            controller: provider.phoneController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  10), // Limit input to 10 digits
                              FilteringTextInputFormatter
                                  .digitsOnly, // Allow only digits
                            ],
                            keyboardType: TextInputType.phone,
                            style: w400_14Poppins(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                          
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              height10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account? ",
                      style: w300_14Poppins(
                        color: Colors.black,
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: Text(
                      "Sign Up",
                      style: w500_14Poppins(color: Colors.black87),
                    ),
                  )
                ],
              ),
              Spacer(),
              TermsAndConditions(text: "signing",),
              height10,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 40,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (
                         provider. phoneController.length !=10) {
                          CustomToast.showErrorToast(
                              msg:
                                  "Please ensure your mobile number is a valid 10-digit format");
                        } else{
                        final phone = provider.phoneController.text.trim();
                        if (phone.isNotEmpty) {
                          provider.signIn(phone,context);
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Phoneotpscreen(
                                      phoneNumber:
                                          provider.phoneController.text,
                                    )));
                          
                        } else {
                          CustomToast.showErrorToast(
                              msg: "Please enter a phone number");
                        }}
                      
                      }
                    }, // Button is disabled when _isButtonEnabled is false
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? Color(0xffC39C67)
                          : Color(
                              0xffE7E9E8), // Button color changes based on state
                      // onSurface: Colors.grey, // Color for disabled state (onPressed is null)
                    ),
                    child: Text(
                      'Verify',
                      style: w500_14Poppins(
                          color: isButtonEnabled
                              ? Colors.white
                              : Color.fromARGB(255, 20, 28, 24)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class TermsAndConditions extends StatelessWidget {
   TermsAndConditions({super.key,required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: 335.w,
        height: 50,
        child: Wrap(
          children: [
            Text(
              '''By $text in to IOTIQ, you agree to our ''',
              style: w300_13Poppins(color: Color(0xff11271D)),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                ''' Terms & Conditions ''',
                style: w500_13Poppins(color: Color(0xff11271D)),
              ),
            ),
            Text(''' and ''', style: w300_13Poppins(color: Color(0xff11271D))),
            GestureDetector(
              onTap: () {},
              child: Text('''Privacy Policy''',
                  style: w500_13Poppins(color: const Color(0xff11271D))),
            ),
          ],
        ),
      ),
    );
  }
}
