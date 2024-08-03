import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/inner_screen/analysis.dart';
import 'package:fashion_app_admin/widgets/user_list.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../inner_screen/add_prod.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';
import '../widgets/text_widget.dart';
import '../controllers/menucontroller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    final menuProvider = Provider.of<MenuControllers>(context);
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                menuProvider.controlDashboardMenu();
              },
              title: 'Trang chủ',
            ),
            // AnalysisApp(),
            const SizedBox(
              height: 20,
            ),
            // TextWidget(
            //   text: 'Tổng Quan',
            //   textSize: 30,
            //   isTitle: true,
            //   color: color,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // ButtonsWidget(
                  //     onPressed: () {},
                  //     text: 'Xem tất cả',
                  //     icon: Icons.store,
                  //     backgroundColor: AppColor.primaryColor),
                  // const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadProductForm(),
                          ),
                        );
                      },
                      text: 'Thêm sản phẩm',
                      icon: Icons.add,
                      backgroundColor: AppColor.primaryColor),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(text: '   Sản phẩm', color: color,),
                      SizedBox(height: 10,),
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 5,
                          childAspectRatio:
                          size.width < 650 && size.width > 350 ? 0.65 : 0.65,
                        ),
                        desktop: ProductGridWidget(
                          crossAxisCount: 6,
                          childAspectRatio: size.width < 1400 ? 0.65 : 0.65,
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextWidget(text: '   Đơn hàng', color: color,),
                      SizedBox(height: 10,),
                      OrdersList(),
                      SizedBox(height: 20,),
                      TextWidget(text: '   Người dùng', color: color,),
                      SizedBox(height: 10,),
                      UserList(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}