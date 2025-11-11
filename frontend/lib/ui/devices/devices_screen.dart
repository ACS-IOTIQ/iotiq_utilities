import 'package:flutter/material.dart';
import 'package:utility/ui/devices/deviceSubmersive.dart';
import 'package:utility/ui/devices/deviceTanks.dart';
import 'package:utility/ui/devices/deviceValves.dart';
import 'package:utility/ui/devices/devicesBase.dart';
import 'package:utility/utils/app_fonts.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  final GlobalKey<DeviceTanksScreenState> tankScreenKey =
      GlobalKey<DeviceTanksScreenState>();
  final GlobalKey<DeviceTanksScreenState> baseScreenKey =
      GlobalKey<DeviceTanksScreenState>();
  
  final GlobalKey<DeviceSubmersiveScreenState> submerviseScreenKey =
      GlobalKey<DeviceSubmersiveScreenState>();
      
  final GlobalKey<DeviceValvesScreenState> valvesScreenKey =
      GlobalKey<DeviceValvesScreenState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) return;
      // Call when Tanks tab is visible
      if (tabController!.index == 0) {
        baseScreenKey.currentState?.refreshData();
      } else if (tabController!.index == 1) {
        tankScreenKey.currentState?.refreshData();
      } else if (tabController!.index == 2) {
        submerviseScreenKey.currentState?.refreshData();
      } else if (tabController!.index == 3) {
        valvesScreenKey.currentState?.refreshData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController!.dispose();
  }

  void goToTab(int index) {
    tabController!.animateTo(index);
  }

  // Key to access HomeWithTabsState

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              controller: tabController,
              onTap: (index) {},
              unselectedLabelStyle: w400_16Poppins(
                color: const Color(0xff11271D),
              ),
              indicatorColor: const Color(0xffC39C67),
              labelStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "Base"),
                Tab(text: "Tanks"),
                 Tab(text: "Pumps"),
                 Tab(
                     text:
                         "Valves"),
              ],
            ),
          ),

          Expanded(
            child: SizedBox(
              // height: MediaQuery.of(context).size.height * 0.72,
              child: TabBarView(
                controller: tabController,
                children: [
                  DevicesBaseScreen(key: baseScreenKey),
                  DeviceTanksScreen(key: tankScreenKey),
                   DeviceSubmersiveScreen(),
                   DeviceValvesScreen()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
