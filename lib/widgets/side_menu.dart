import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/inner_screen/all_banners.dart';
import 'package:fashion_app_admin/inner_screen/all_category.dart';
import 'package:fashion_app_admin/inner_screen/all_user.dart';
import 'package:fashion_app_admin/inner_screen/analysis.dart';
import 'package:fashion_app_admin/screens/auth/login.dart';
import 'package:fashion_app_admin/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/auth.dart';
import '../inner_screen/all_orders_screen.dart';
import '../inner_screen/all_products.dart';
import '../provider/dark_theme_provider.dart';
import '../screens/main_screen.dart';
import '../services/global_method.dart';
import '../services/utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? _email;
  String? _name;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  @override
  void dispose() {
    if (mounted) {
      _email==null;
      _name==null;
    }
    super.dispose();
  }
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('admin').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);

    final color = Utils(context).color;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                        color:
                        Theme.of(context).colorScheme.background,
                        width: 3),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/3177/3177440.png"
                      ),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                TextWidget(text: "Quản trị viên: $_name", color: color, isTitle: true,),
                TextWidget(text: "Email: $_email", color: color, isTitle: false),
              ],
            ),

          ),

          DrawerListTile(
            title: "Trang chủ",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: Icons.home_filled, colorLight: Colors.white, colorDark: Colors.black,
          ),
          DrawerListTile(
            title: "Quản lý người dùng",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllUserScreen(),
                ),
              );
            },
            icon: IconlyBold.user_2,colorLight: Colors.white, colorDark: Colors.black,
          ),
          // DrawerListTile(
          //   title: "Số liệu phân tích",
          //   press: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (context) => AnalysisApp(),
          //       ),
          //     );
          //   },
          //   icon: IconlyBold.chart,colorLight: Colors.white, colorDark: Colors.black,
          // ),
          DrawerListTile(
            title: "Tất cả sản phẩm",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllProductsScreen()));
            },
            icon: Icons.store,colorLight: Colors.white, colorDark: Colors.black,
          ),
          DrawerListTile(
            title: "Tất cả đơn hàng",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllOrdersScreen()));
            },
            icon: IconlyBold.buy,colorLight: Colors.white, colorDark: Colors.black,
          ),
          DrawerListTile(
            title: "Danh mục",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllCategoryScreen()));
            },
            icon: Icons.category,colorLight: Colors.white, colorDark: Colors.black,
          ),
          DrawerListTile(
            title: "Quản lý quảng cáo",
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllBannerScreen()));
            },
            icon: Icons.filter_outlined,colorLight: Colors.white, colorDark: Colors.black,
          ),
          SwitchListTile(
              title: const Text('Giao diện'),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: theme,
              activeColor: color,
              selected: true,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              }),
          DrawerListTile(
            title: "Đăng xuất",
            press: () {
              GlobalMethods.warningDialog(title: "Thông báo",
                  subtitle: "Bạn có muốn đăng xuất không",
                  fct: () async {
                    await authInstance.signOut();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }, context: context);
            },
            icon: Icons.logout,colorLight: Colors.red, colorDark: Colors.red,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon, required this.colorLight, required this.colorDark,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;
  final Color colorLight;
  final Color colorDark;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? colorLight : colorDark;

    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
          color: color,
        ),
        title: TextWidget(
          text: title,
          color: color,
        ));
  }
}