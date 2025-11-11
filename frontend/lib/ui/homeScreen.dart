import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/common_appbar.dart';
import 'package:utility/ui/customDrawer.dart';
import 'package:utility/ui/devices/devices_screen.dart';
import 'package:utility/ui/devices/remove_device.dart';
import 'package:utility/ui/setup/select_conditionAction_screen.dart';
import 'package:utility/ui/setup/setup_screen.dart';
import 'package:utility/ui/space/add_device.dart';
import 'package:utility/ui/space/home_space_screen.dart';
import 'package:utility/ui/space/setUpSpace_bottomSheet.dart';
import 'package:utility/ui/usage/usage_screen.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_bottomsheet.dart';
import 'package:utility/utils/images.dart';

class Homescreen extends StatefulWidget {
  Homescreen({
    super.key,
    this.startIndex = 0,
    this.phoneNumber,
    this.showBottomSheet = false,
    this.nestedTabIndex,
  });
  final int? startIndex;
  String? phoneNumber;
  final bool showBottomSheet;
  final int? nestedTabIndex;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0; // Track the index of the selected tab
  late CommonProvider commonProvider;
  late SpacesProvider spacesProvider;
  bool _bottomSheetShown = false;
  final GlobalKey<DevicesScreenState> deviceKey = GlobalKey();
  final GlobalKey<HomeSpaceScreenState> homeScreenKey = GlobalKey();

  // List of pages for each bottom navigation item
  final List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the selected tab
    });
  }

  void navigateToHomeTab(int tabIndex) {
    setState(() {
      _currentIndex = 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      deviceKey.currentState?.goToTab(tabIndex);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    commonProvider = Provider.of<CommonProvider>(context, listen: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.showBottomSheet && !_bottomSheetShown) {
      _bottomSheetShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customShowDialog(context, const SetupspaceBottomsheet());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonProvider = Provider.of<CommonProvider>(context, listen: false);
      print("access token ${commonProvider.accessToken.toString()}");
    });
    _currentIndex = widget.startIndex!;

    _pages.addAll([
      HomeSpaceScreen(key: homeScreenKey),
      DevicesScreen(key: deviceKey),
      SetupScreen(),
      const UsageScreen(),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 1 && widget.nestedTabIndex != null) {
        deviceKey.currentState?.goToTab(widget.nestedTabIndex!);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeScreenKey.currentState != null) {
        print("HomeSpaceScreenState found, calling fetchData()");
        // homeScreenKey.currentState?.fetchData();
      } else {
        print("HomeSpaceScreenState is null!");
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      spacesProvider = Provider.of<SpacesProvider>(context, listen: false);
      spacesProvider.initializeDefaultSpace(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: commonAppBar(context, phoneNumber: widget.phoneNumber),
          endDrawer: const Customdrawer(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () {
              customShowDialog(
                context,
                addBottomSheet(context),
                backGroundColor: const Color(0xffFBFAF5),
              );
            },
            child: const Icon(Icons.add, color: Color(0xffC39C67)),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: SizedBox(
              height: 71.h,
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
                backgroundColor: const Color(
                  0xff11271D,
                ), // Set the background color of the Bottom Navigation Bar
                selectedItemColor: const Color(
                  0xffC39C67,
                ), // Set the color of the selected item
                unselectedItemColor:
                    Colors.white, // Set the color of unselected items
                type: BottomNavigationBarType
                    .fixed, // Type of the Bottom Navigation Bar
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: _currentIndex == 1
                        ? SvgPicture.asset(
                            AppImages.devicesIcon,
                            width: 27,
                            height: 27,
                            color: const Color(0xffC39C67),
                          )
                        : SvgPicture.asset(
                            AppImages.devicesIcon,
                            width: 27,
                            height: 27,
                            color: Colors.white,
                          ),
                    label: 'Devices',
                  ),
                  BottomNavigationBarItem(
                    icon: _currentIndex == 2
                        ? SvgPicture.asset(
                            AppImages.setupIcon,
                            width: 27,
                            height: 27,
                            color: const Color(0xffC39C67),
                          )
                        : SvgPicture.asset(
                            AppImages.setupIcon,
                            width: 27,
                            height: 27,
                            color: Colors.white,
                          ),
                    label: 'Setup',
                  ),
                  BottomNavigationBarItem(
                    icon: _currentIndex == 3
                        ? SvgPicture.asset(
                            AppImages.usageIcon,
                            width: 27,
                            height: 27,
                            color: const Color(0xffC39C67),
                          )
                        : SvgPicture.asset(
                            AppImages.usageIcon,
                            width: 27,
                            height: 27,
                            color: Colors.white,
                          ),
                    label: 'Usage',
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xff11271D),
                  child: Column(
                    children: [
                      height10,
                      Container(
                        height: MediaQuery.of(context).size.height * 0.84,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Color.fromARGB(255, 239, 238, 238),
                        ),
                        child: _pages[_currentIndex],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  addBottomSheet(BuildContext context) {
    return SizedBox(
      // height: 120.h,
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
                color: const Color(0xffEBEBEB),
              ),
            ),
          ),

          height20,
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDeviceScreen(),
                ),
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Add a new Device",
                    style: w500_16Poppins(color: const Color(0xff11271D)),
                  ),
                  width10,
                  const Icon(Icons.arrow_right, color: Color(0xffC39C67)),
                ],
              ),
            ),
          ),
          height15,
          InkWell(
            onTap: () async {
              final success = await Provider.of<CommonProvider>(
                context,
                listen: false,
              ).fetchUserProfile(context);

              if (success != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectConditionactionScreen(),
                  ),
                );
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Create setup",
                    style: w500_16Poppins(color: const Color(0xff11271D)),
                  ),
                  width10,
                  const Icon(Icons.arrow_right, color: Color(0xffC39C67)),
                ],
              ),
            ),
          ),
          height15,
          InkWell(
            onTap: () {
              customShowDialog(context, RemoveDeviceBottomsheet());
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " Remove device",
                    style: w500_16Poppins(color: const Color(0xff11271D)),
                  ),
                  width10,
                  const Icon(Icons.arrow_right, color: Color(0xffC39C67)),
                ],
              ),
            ),
          ),
          height15,
        ],
      ),
    );
  }
}
