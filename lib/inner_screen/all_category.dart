import 'package:fashion_app_admin/inner_screen/add_banner.dart';
import 'package:fashion_app_admin/inner_screen/add_category.dart';
import 'package:fashion_app_admin/widgets/banner_widget.dart';
import 'package:fashion_app_admin/widgets/grid_banner.dart';
import 'package:fashion_app_admin/widgets/grid_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/menucontroller.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';


class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MenuControllers>().getAllCategoryScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Header(
                        fct: () {
                          context.read<MenuControllers>().controlAllCategoryMenu();
                        },
                        title: 'Tất cả danh mục',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ButtonsWidget(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UploadCategoryForm(),
                                ),
                              );
                            },
                            text: 'Thêm danh mục',
                            icon: Icons.add,
                            backgroundColor: Colors.blueAccent),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Responsive(
                        mobile: CategoryGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                          size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false,
                        ),
                        desktop: CategoryGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}