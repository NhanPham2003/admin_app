import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/menucontroller.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';


class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MenuControllers>().getAllProductScaffoldKey,
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
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Header(
                        fct: () {
                          context.read<MenuControllers>().controlProductsMenu();
                        },
                        title: 'Tất cả sản phẩm',
                      ),
                      // Container(
                      //   width: size.width,
                      //   height: 1, // Đây là chiều cao của đường kẻ
                      //   color: ,
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 5,
                          childAspectRatio: size.width < 650 && size.width > 350 ? 0.65 : 0.65,
                          isInMain: false,
                        ),
                        desktop: ProductGridWidget(
                          crossAxisCount: 5,
                          childAspectRatio: size.width < 1400 ? 0.60 : 0.75,
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