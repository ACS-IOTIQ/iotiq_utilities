
import 'dart:io';

import'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility/profile/update_phoneNumber.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class Profile extends StatefulWidget {
  const Profile({super.key,this.phoneNumber});
  final String? phoneNumber;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
  final prefs = await SharedPreferences.getInstance();
  final storedName = prefs.getString('user_name');
  print('Loaded user_name from SharedPreferences: $storedName');
  setState(() {
    userName = storedName;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
      ),
      body: Consumer<CommonProvider>(
        builder: (context,commonProvider,child) {
          return Column(
            children: [
              SizedBox(
                height: 17,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(0, 6),
                      )
                    ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:   _imageFile != null
          ? Image.file(
              _imageFile!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/background.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
                ),
              ),
              height15,
              Text(commonProvider.userName== null?commonProvider.userName: "${commonProvider.userName}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
           height5,
              Text("@david_miller1234",style: w400_15Poppins(color: Colors.grey),),
              height15,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color:Color(0xffF5F1E5)),
                  color: Colors.white,
                ),
                child:
                Column(
                  children: [
                    
                    Divider(height: 1, color: Color(0xffF5F1E5)),
                    _infoTile(
                      context: context,
                      icon: Icons.phone_outlined,
                      onPressed: (){
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdatePhoneNumberScreen(
                                     phoneNumber: commonProvider.phoneNumber,
                                     name: commonProvider.userName,
                                        )));
                      },
                      label: "Phone Number",
                      value: commonProvider.phoneNumber
                      == null?"+91 ${commonProvider.phoneNumber}": "+91 ${commonProvider.phoneNumber}",
                      iconColor: Color(0xffC39C67),
                      iconTrailing: Icons.edit_outlined
                    ),
                    Divider(height: 1, color: Color(0xffF5F1E5)),
                    _infoTile(
                      context: context,
                      icon: Icons.calendar_month,
                      label: "Joined On",
                      value: "24 July 2019",
                      iconColor: Color(0xffC39C67),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(padding: EdgeInsets.all(16),
        child: ElevatedButton.icon(style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffF5F1E5), padding:EdgeInsets.symmetric(vertical: 14),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),

        )
        ),onPressed: (){
          imagePickerBottomSheetProfilePic();
        },icon: Icon(Icons.file_upload_outlined,color: Color(0xFFD4AE7B),),
            label: Text('Upload New Profile Image',style: TextStyle(
                fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black
            ),)),),
    );
  }

  

  /// Image Picker Profile Pic
  Future<void> imagePickerBottomSheetProfilePic() async {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(
                // color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                height10,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                       ),
                  ),
                ),
                height10,
                ListTile(
                    leading: Icon(Icons.camera_alt_outlined,color: Color(0xffC39C67),),
                    title: Text(
                      'Take a Photo',
                      style: w400_16Poppins(color:Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();

                      /// Get from camera
                      getFromCameraProfile();
                    }),
                ListTile(
                    leading: Icon(Icons.photo,color: Color(0xffC39C67),),
                    title: Text(
                      'Add New Profile Picture',
                      style: w400_16Poppins(color: Colors.black)),
                    
                    onTap: () {
                      Navigator.of(context).pop();

                      /// Get from Gallery
                      getFromGalleryProfile();
                    }),
              
              ],
            ),
          );
        });
  }

 

  /// Get for Profile
  Future<void> getFromCameraProfile() async {
     final pickedFile = await _picker.pickImage(source: ImageSource.camera,maxWidth: 1800,
      maxHeight: 1800,);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

   Future<void> getFromGalleryProfile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 1800,
      maxHeight: 1800,);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


}
Widget _infoTile({
  required IconData icon,
  final IconData? iconTrailing,
  required String label,
  required String value,
  required  Color iconColor,
  final VoidCallback? onPressed,
  required BuildContext context,
}
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: SizedBox(
            width: MediaQuery.of(context).size.width*1,

      height: 30.h,
      child:
      
      
       Row(
        children: [
           Icon(icon, color: iconColor,size: 18,),
          width15,
          Container(
            width: MediaQuery.of(context).size.width*0.56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: w300_14Poppins(color: Colors.black)),
            height5,
            Flexible(
              child: Text(
                value,
                style:w500_15Poppins(color: Colors.black),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
              ],
            ),
          ),
       
          IconButton(icon: Icon(iconTrailing, color: iconColor,size: 24,),onPressed: onPressed,),

        ],
      ),
    ),
  );
}
