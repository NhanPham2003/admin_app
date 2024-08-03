
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.fct,
    required this.buttonText,
    this.primary = AppColor.primaryColor,
  }) : super(key: key);
  final Function fct;
  final String buttonText;
  final Color primary;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primary, // background (button) color
          ),
          onPressed: () {
            fct();
            // _submitFormOnLogin();
          },
          child: TextWidget(
            text: buttonText,
            textSize: 18,
            color: Colors.white,
            isTitle: true,
          )),
    );
  }
}