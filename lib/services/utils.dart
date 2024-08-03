import 'package:fashion_app_admin/consts/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';



class Utils {
  BuildContext context;
  Utils(this.context);

  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  Color get color => getTheme ? Colors.white : Colors.black;
  Color get colorSub => getTheme ? AppColor.primaryColor : AppColor.primaryColor;
  Color get colorSale => getTheme ? Colors.white : AppColor.subTextColor;
  Color get colorCard => getTheme ? Color(0xff0a0d2c) : Colors.white;
  Size get getScreenSize => MediaQuery.of(context).size;
}