import 'package:flutter/material.dart';

class MenuControllers extends ChangeNotifier {
  // Main & Dashboard
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // All products
  final GlobalKey<ScaffoldState> _allProductScaffoldKey = GlobalKey<ScaffoldState>();
  // Add Products page
  final GlobalKey<ScaffoldState> _addProductScaffoldKey =
  GlobalKey<ScaffoldState>();
  // Edit product screen
  final GlobalKey<ScaffoldState> _editProductScaffoldKey =
  GlobalKey<ScaffoldState>();
  // Orders screen
  final GlobalKey<ScaffoldState> _ordersScaffoldKey =
  GlobalKey<ScaffoldState>();
  // Add Products page
  final GlobalKey<ScaffoldState> _allBannerScaffoldKey =
  GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addBannerScaffoldKey =
  GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _allUsersScaffoldKey= GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _allCategoryScaffoldKey= GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addCategoryScaffoldKey= GlobalKey<ScaffoldState>();
  // Getters
  GlobalKey<ScaffoldState> get getAllCategoryScaffoldKey => _allCategoryScaffoldKey;
  // Main & Dashboard scaffold key
  GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;
  // get all product Scaffold Key
  GlobalKey<ScaffoldState> get getAllProductScaffoldKey => _allProductScaffoldKey;
  // get Add product Scaffold Key
  GlobalKey<ScaffoldState> get getAddProductscaffoldKey =>
      _addProductScaffoldKey;
  // get Edit product screen Scaffold Key
  GlobalKey<ScaffoldState> get getEditProductScaffoldKey =>
      _editProductScaffoldKey;
  // get Orders screen Scaffold Key
  GlobalKey<ScaffoldState> get getOrdersScaffoldKey => _ordersScaffoldKey;
  // get all product Scaffold Key
  GlobalKey<ScaffoldState> get getGridBannerScaffoldKey => _allBannerScaffoldKey;
  GlobalKey<ScaffoldState> get getAddBannerScaffoldKey => _addBannerScaffoldKey;
  GlobalKey<ScaffoldState> get getAllUserScaffoldKey => _allUsersScaffoldKey;
  GlobalKey<ScaffoldState> get getAddCategoryScaffoldKey => _addCategoryScaffoldKey;
  // Callbacks
  void controlAddCategoryMenu() {
    if (!_addCategoryScaffoldKey.currentState!.isDrawerOpen) {
      _addCategoryScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlAllCategoryMenu() {
    if (!_allUsersScaffoldKey.currentState!.isDrawerOpen) {
      _allUsersScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlBannerMenu() {
    if (!_allBannerScaffoldKey.currentState!.isDrawerOpen) {
      _allBannerScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlUserMenu() {
    if (!_allUsersScaffoldKey.currentState!.isDrawerOpen) {
      _allUsersScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlDashboardMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlProductsMenu() {
    if (!_allProductScaffoldKey.currentState!.isDrawerOpen) {
      _allProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductsMenu() {
    if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlAddBannerMenu() {
    if (!_addBannerScaffoldKey.currentState!.isDrawerOpen) {
      _addBannerScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlEditProductsMenu() {
    if (!_editProductScaffoldKey.currentState!.isDrawerOpen) {
      _editProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllOrder() {
    if (!_ordersScaffoldKey.currentState!.isDrawerOpen) {
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }
}