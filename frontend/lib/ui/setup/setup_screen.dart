import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:utility/model/get_all_setupDevices_model.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/setup/select_conditionAction_screen.dart';
import 'package:utility/utils/appColors.dart';
import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/custom_button.dart';
import 'package:utility/utils/images.dart';
class SetupScreen extends StatefulWidget {
  SetupScreen({
    super.key,
    this.selectedConditionName,
    this.selectedActionDeviceName,
    this.selectedActionParameterName,
    this.progressValue,
    this.selectedConditionParameterName,
  });
  String? selectedConditionName;
  int? selectedActionDeviceName;
  String? selectedActionParameterName;
  String? selectedConditionParameterName;
  final double? progressValue;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  GetAllSetupDevicesModel? setupDevices;
  // List of 10 items
  late SpacesProvider spacesProvider;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    spacesProvider = Provider.of<SpacesProvider>(listen: false, context);

    // String selectedSpaceId =
    //     spacesProvider.selectedSpaceId ??
    //     "default_space_id"; // Replace as needed
    spacesProvider.fetchSetupDevices(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SpacesProvider, CommonProvider>(
      builder: (contex, provider, commonProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              height20,
              provider.setupDevices == null ||
                      provider.setupDevices!.data!.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        children: [
                          height70,
                          height70,
                          height15,

                          CircleAvatar(
                            radius: 65,
                            backgroundColor: const Color(0xffC39C67),
                            child: CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,

                                radius: 36,
                                child: SvgPicture.asset(
                                  AppImages.deviceSetup,
                                  color: const Color(0xffC39C67),
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            ),
                          ),
                          height20,
                          SizedBox(
                            width: 250.w,
                            height: 50.h,
                            child: Text(
                              "No Setup created for the selected Space so far. Create a setup to automate your appliances",
                              style: w400_16Poppins(
                                color: const Color(0xff828282),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          height20,
                          CustomButton(
                            height: 45,
                            width: 200,
                            borderRadius: 18,
                            onTap: () async {
                              // customShowDialog(context, SetupBottomsheet());
                              await commonProvider.fetchUserProfile(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectConditionactionScreen(),
                                ),
                              );
                            },
                            buttonText: "Create Setup",
                            textColor: Colors.white,
                            buttonColor: const Color(0xffC39C67),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.65,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.setupDevices!.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 356.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: const Color(0xffF6F2E7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      provider
                                                                  .setupDevices!
                                                                  .data![index]
                                                                  .condition!
                                                                  .switchNo ==
                                                              null



                                                
                                                          ? provider
                                                                .setupDevices!
                                                                .data![index]
                                                                .condition!
                                                                .deviceName!
                                                          : "${provider.setupDevices!.data![index].condition!.deviceName!} - ${provider.setupDevices!.data![index].condition!.switchNo!}",
                                                      style: w500_16Poppins(
                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    provider
                                                                .setupDevices!
                                                                .data![index]
                                                                .condition!
                                                                .deviceType! ==
                                                            "base"
                                                        ? baseConditionViewCustomCard(
                                                            provider,
                                                            index,
                                                          )
                                                        : tankConditionViewCustomcard(
                                                            provider,
                                                            index,
                                                          ),
                                                  ],
                                                ),
                                                height5,
                                                Consumer<SpacesProvider>(
                                                  builder: (context, provider, child) {
                                                    final actions =
                                                        provider
                                                            .setupDevices
                                                            ?.data![index]
                                                             .condition!
                                                            .actions ??
                                                        [];

                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: actions.length,
                                                      itemBuilder: (context, index) {
                                                        final action =
                                                            actions[index];
                                                        return customCardTank(
                                                          context,
                                                          // action.deviceId!,
                                                          action.setStatus!,
                                                          "${action.deviceName!} -  ${action.switchNo!}",
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        height5,
                                        const Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            InkWell(
                              onTap: () async {
                                final success =
                                    await Provider.of<CommonProvider>(
                                      context,
                                      listen: false,
                                    ).fetchUserProfile(context);

                                if (success != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectConditionactionScreen(),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xffC39C67),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                      ),
                                      width10,
                                      Text(
                                        "Add more conditions",
                                        style: w500_16Poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              height50,
            ],
          ),
        );
      },
    );
  }

  Container baseConditionViewCustomCard(SpacesProvider provider, int index) {
    return Container(
      height: 20.h,
      width: 24.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(color: Appcolors.appColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 8.h,
          width: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                provider.setupDevices!.data![index].condition!.status == "off"
                ? Colors.red
                : Colors.green,
          ),
        ),
      ),
    );
  }

  Padding tankConditionViewCustomcard(SpacesProvider provider, int index) {
    final condition = provider.setupDevices!.data![index].condition!;
    double min =
        double.tryParse(condition.minimum?.toString() ?? '0')?.clamp(0, 100) ??
        0;
    double max =
        double.tryParse(condition.maximum?.toString() ?? '0')?.clamp(0, 100) ??
        0;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          TankFillIndicator(percentage: min, color: Colors.blue.shade300),
          width5,
          Text("-", style: w500_18Poppins()),

          width5,
          TankFillIndicator(percentage: max, color: Colors.blue.shade300),
        ],
      ),
    );
  }

  Padding customCardTank(
    BuildContext context,
    // String deviceId,
    String setStatus,
    String deviceName,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        // height: 55.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: ListTile(
          onTap: () {},
          title: Text(deviceName, style: w500_14Poppins(color: Colors.black)),
          // subtitle: Text(deviceId, style: w400_15Poppins(color: Colors.black)),
          trailing: Text(
            setStatus,
            style: w500_14Poppins(
              color: setStatus == "on" ? Colors.green : Colors.red,
            ),
          ),
          tileColor: Colors.grey[100],
        ),
      ),
    );
  }
}

class TankFillIndicator extends StatelessWidget {
  final double percentage;
  final Color color;

  const TankFillIndicator({
    super.key,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double containerHeight = MediaQuery.of(context).size.height * 0.035;
    final double fillHeight = (containerHeight * (percentage / 100)).clamp(
      0,
      containerHeight,
    );

    return Container(
      height: containerHeight,
      width: 35,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Fill background
          ClipRRect(
            borderRadius: BorderRadiusGeometry.vertical(
              bottom: Radius.circular(20),
              top: Radius.circular(20),
            ),
            child: Container(
              height: fillHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.6), color],
                ),
              ),
            ),
          ),

          // Percentage label
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
