import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:utility/profile/update_phoneNumber_otp.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_toast.dart';
import 'package:utility/utils/images.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
   UpdatePhoneNumberScreen({super.key,required this.phoneNumber,required this.name});
  final String phoneNumber;
  final String name;
  @override
  _UpdatePhoneNumberScreenState createState() => _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController updatePhoneController = TextEditingController();
  bool _isButtonEnabled = true;
  late CommonProvider commonProvider;
  final TextEditingController updatePhoneController = TextEditingController();
  final TextEditingController updateNameController = TextEditingController();


  // Update the button state when text changes
  void _onTextChanged() {
    setState(() {
      // _isButtonEnabled = updatePhoneController.text.isNotEmpty; // Check if the text is not empty
    });
  }

  @override
  void dispose() {
    updatePhoneController.removeListener(
        _onTextChanged); // Remove the listener when the widget is disposed
    super.dispose();
    // commonProvider.updatePhoneController.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commonProvider = Provider.of<CommonProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
     updatePhoneController.text = widget.phoneNumber;
     updateNameController.text = widget.name;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Update your phone number",
          style: w400_14Poppins(color: Color(0xff11271D)),
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
                child: Container(
                  width: 370,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: updateNameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              10), // Limit input to 10 digits
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits
                        ],
                        keyboardType: TextInputType.phone,
                        style: w400_14Poppins(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: w400_14Poppins(color: Colors.grey.shade500),

                          border: InputBorder.none, // No border
                          filled: true,
                          fillColor: Colors.white,
                          // Background color
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (value.length != 10) {
                            return 'Please enter exactly 10 digits';
                          }
                          return null;
                        },
                      ),
                      Divider(),
                      TextFormField(
                        controller: updatePhoneController,
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
                          } else if (value.length != 10) {
                            return 'Please enter exactly 10 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            
              Spacer(),
              height10,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 40,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (updatePhoneController.length > 2 ||
                            updatePhoneController.length < 10) {
                          print("10 didgits");
                          CustomToast.showErrorToast(
                              msg:
                                  "Please ensure your mobile number is a valid 10-digit format");
                        }
                      
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdatePhoneOtpScreen(
                                      phoneNumber:
                                         updatePhoneController.text,
                                    )));
                      }
                    }, // Button is disabled when _isButtonEnabled is false
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? Color(0xffC39C67)
                          : Color(
                              0xffE7E9E8), // Button color changes based on state
                      // onSurface: Colors.grey, // Color for disabled state (onPressed is null)
                    ),
                    child: Text(
                      'Update Phone Number',
                      style: w500_14Poppins(
                          color: _isButtonEnabled
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


