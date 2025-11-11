import 'package:flutter/material.dart';

import 'package:utility/utils/app_fonts.dart';
import 'package:utility/utils/images.dart';

Future<dynamic> customShowDialog(
  BuildContext context,
  Widget dialogWidget, {
  double? height,
  Color? color,
  RouteSettings? routeSettings,
  bool enableDrag = false,
  bool isDismissible = true,
  Color? backGroundColor,
}) {
  return showModalBottomSheet(
      isDismissible: isDismissible,
      isScrollControlled: true,
      routeSettings: routeSettings,
      enableDrag: enableDrag,
      backgroundColor: backGroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: height,
            child: dialogWidget,
          ),
        );
      }).whenComplete(() {
    // commonProvider?.updateSelectedSound();
  });
}

Future<void> showAlertDialog(
  BuildContext context, {
  Widget? title,
  Widget? body,
  Color? backgrounColor,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 7),
        title: title,
        content: body,
        backgroundColor: Colors.transparent,
      );
    },
  );
}

Widget showDialogCustomHeader(BuildContext context, {required String headerTitle, bool removeDivider = false, Color? headerColor, bool backNavigationRequired = true, VoidCallback? backButtonFuc}) {
  return Container(
      decoration: BoxDecoration(
          // color: headerColor ?? webinarThemesProviders.colors.headerColor,
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20,
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xff202223)),
            ),
          ),
          height10,
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headerTitle,
                  style: w500_14Poppins(color: Theme.of(context).hoverColor),
                ),
                if (backNavigationRequired)
                  GestureDetector(
                    onTap: backButtonFuc ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          removeDivider
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: const Divider(),
                ),
        ],
      ),
    );
}
