import 'package:flutter/material.dart';
import 'package:utility/utils/app_fonts.dart';
class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.buttonText,
      this.onTap,
      this.buttonColor = Colors.blue,
      this.textColor = Colors.black,
      this.height,
      this.width,
      this.buttonTextStyle,
      this.borderColor,
      this.isLoading = false,
      this.borderRadius,
      this.leadingWidget})
      : super(key: key);

  final String buttonText;
  final VoidCallback? onTap;
  final Color buttonColor;
  final Color textColor;
  double? height;
  double? width;
  TextStyle? buttonTextStyle;
  double? borderRadius;
  final bool isLoading;
  final Color? borderColor;
  Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        height: height ?? 40,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.transparent),
            color: buttonColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 5)),
        child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      leadingWidget ?? const IgnorePointer(),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        buttonText,
                        style: buttonTextStyle ??
                            w400_16Poppins(color: Colors.white),
                      ),
                    ],
                  )),
      ),
    );
  }
}
