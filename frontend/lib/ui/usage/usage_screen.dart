import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:utility/ui/usage/monthlyUsage_screen.dart';
import 'package:utility/ui/usage/todayUsage_screen.dart';
import 'package:utility/ui/usage/weeklyUsage_screen.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

class UsageScreen extends StatefulWidget {
  const UsageScreen({super.key});

  @override
  State<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:Container(
        color: Color(0xffFBFAF5),
        child: Column(
          children: [
              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xffF5F1E5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ButtonsTabBar(
                                        onTap: (index) {
                                       
                                        },
                                        contentPadding:
                                            const EdgeInsets.all(8),
                                        buttonMargin: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Color(0xffC39C67)),
                                        // backgroundColor: AppColors.primColor,
                                        unselectedBackgroundColor:
                                            Colors.transparent,
                                        unselectedLabelStyle: w400_14Poppins(
                                            color: Colors.black),
                                        labelStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        tabs: const [
                                          Tab(
                                            iconMargin: EdgeInsets.all(8),
                                            text: "Today’s Usage",
                                            height: 30,
                                          ),
                                          Tab(text: "Weekly Usage"),
                                          Tab(text: "Monthly Usage"),
                                         
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                    TodayusageScreen(),
                                    WeeklyusageScreen(),
                                    MonthlyUsageScreen(),
                                      ],
                                    ),
                                  )
          ],
        ),
      ) ,
    );
  }
}