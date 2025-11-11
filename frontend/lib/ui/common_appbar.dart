import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/auth/loading_screen.dart';
import 'package:utility/main.dart';
import 'package:utility/model/spaces/get_all_spaces.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/ui/space/setUpSpace_bottomSheet.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_bottomsheet.dart';
import 'package:utility/utils/images.dart';


AppBar commonAppBar(BuildContext context, {String? phoneNumber}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xff11271D),
    title: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen()),
        );
        MyApp.restartApp(context);
        print("app is refreshed");
      },
      child: SvgPicture.asset(AppImages.appLogo, height: 28, width: 28),
    ),
    actions: [
         Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ), // You can customize the icon if you like
                onPressed: () {
                  Scaffold.of(
                    context,
                  ).openEndDrawer(); // Open the right-side drawer
                },
              );
            },
          ),
          // Consumer<CommonProvider>(
          //   builder: (context, commonProvider, child) {
          //     return 
              // commonProvider.signUpSuccess == true
              //     ? const SizedBox()
              //     : InkWell(
              //         onTap: () {
              //           customShowDialog(
              //             context,
              //             ListOfSpacesBottomSheet(spaceName: phoneNumber),
              //           );
              //         },
              //         child: Container(
              //           height: 30,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(18),
              //             color: const Color.fromARGB(255, 74, 96, 85),
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(6.0),
              //             child: Row(
              //               children: [
              //                 const Icon(
              //                   Icons.home,
              //                   color: Color(0xffC39C67),
              //                   size: 18,
              //                 ),
              //                 width5,
              //                 Text(
              //                   commonProvider.selectedSpaceName ??
              //                       phoneNumber ??
              //                       "",
              //                   style: w400_12Poppins(color: Colors.white),
              //                 ),
              //                 width5,
              //                 const Padding(
              //                   padding: EdgeInsets.only(bottom: 20.0),
              //                   child: Icon(
              //                     Icons.arrow_drop_down,
              //                     color: Color(0xffC39C67),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
          //   },
          // ),
          width5,
    
    ],
  );
}

class ListOfSpacesBottomSheet extends StatefulWidget {
  ListOfSpacesBottomSheet({super.key, this.spaceName});
  String? spaceName;

  @override
  State<ListOfSpacesBottomSheet> createState() =>
      _ListOfSpacesBottomSheetState();
}

class _ListOfSpacesBottomSheetState extends State<ListOfSpacesBottomSheet> {
  int? selectedIndex;

  late SpacesProvider spacesProvider;

  @override
  void initState() {
    super.initState();
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);
    spacesProvider.fetchSpaces(context).then((value) {
      if (value != null && value.data.length == 1) {
        final onlySpace = value.data[0];
        spacesProvider.setSelectedSpaceAndDevice(onlySpace.id);

        // Also update the CommonProvider's selected space name
        Provider.of<CommonProvider>(
          context,
          listen: false,
        ).setSelectedSpaceName(onlySpace.spaceName);

        setState(() {
          selectedIndex = 0;
        });
      } else if (spacesProvider.selectedSpaceId == null &&
          value != null &&
          value.data.isNotEmpty) {
        final defaultSpace = value.data[0];
        spacesProvider.setSelectedSpaceAndDevice(defaultSpace.id);
        Provider.of<CommonProvider>(
          context,
          listen: false,
        ).setSelectedSpaceName(defaultSpace.spaceName);

        setState(() {
          selectedIndex = 0;
        });
      }
    });
  }

  // void updateSelectedIndex(List<Datum> spaces) {
  //   final selectedId = spacesProvider.selectedSpaceId;
  //   if (selectedId != null) {
  //     final index = spaces.indexWhere((space) => space.id == selectedId);
  //     if (index != -1) {
  //       setState(() {
  //         selectedIndex = index;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SpacesProvider, CommonProvider>(
      builder: (context, spaceProvider, commonProvider, child) {
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
                  color: const Color(0xffEBEBEB),
                ),
              ),
            ),
            height10,
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                width60,
                width50,
                Text("Spaces", style: w600_16Poppins(color: Colors.black)),
              ],
            ),
            height10,
            SizedBox(
              height: 180.h,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<GetAllSpacesModel?>(
                  future: spaceProvider.fetchSpaces(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Center(
                        child: Text(
                          'Failed to load spaces.',
                          style: w400_15Poppins(color: Colors.black),
                        ),
                      );
                    }

                    if (snapshot.data!.data.isEmpty) {
                      return Center(
                        child: Text(
                          'Data not found',
                          style: w400_15Poppins(color: Colors.black),
                        ),
                      );
                    }

                    List<GetAllSpacesDataModel> spaces = snapshot.data!.data;

                    final selectedId = spacesProvider.selectedSpaceId;
                    if (selectedId != null) {
                      final selectedSpace = spaces.firstWhere(
                        (space) => space.id == selectedId,
                        orElse: () => spaces[0],
                      );

                      // Remove and re-insert at the top
                      spaces.removeWhere((space) => space.id == selectedId);
                      spaces.insert(0, selectedSpace);

                      // Make sure selectedIndex = 0
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (selectedIndex != 0) {
                          setState(() {
                            selectedIndex = 0;
                          });
                        }
                      });
                    }

                    return ListView.separated(
                      itemCount: spaces.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, int) =>
                          const Divider(color: Colors.black12),
                      itemBuilder: (context, int) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            // Inside onTap in ListOfSpacesBottomSheet
                            onTap: () async {
                              String spaceId = spaces[int].id;
                              widget.spaceName = spaces[int].spaceName;

                              spaceProvider.setSelectedSpaceAndDevice(spaceId);
                              commonProvider.setSelectedSpaceName(
                                widget.spaceName!,
                              );

                              setState(() {
                                selectedIndex = int;
                              });

                              // Optionally notify or reload home screen
                              Navigator.pop(context);
                            },

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Frame.svg",
                                      width: 40,
                                      height: 40,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text: "Home:",
                                                  style: TextStyle(
                                                    color: Colors.brown,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: spaces[int].spaceName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            spaces[int].address,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      selectedIndex == int
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: selectedIndex == int
                                          ? const Color(0xffC39C67)
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            height10,
            Container(
              height: 58.h,
              width: 220.w,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  customShowDialog(context, const SetupspaceBottomsheet());
                },
                icon: const Icon(Icons.add, color: Color(0xffC39C67)),
                label: Text(
                  "Add New Space",
                  style: w500_14Poppins(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 237, 228, 203),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
