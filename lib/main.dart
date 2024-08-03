import 'package:fashion_app_admin/controllers/menucontroller.dart';
import 'package:fashion_app_admin/provider/dark_theme_provider.dart';
import 'package:fashion_app_admin/provider/product_provider.dart';
import 'package:fashion_app_admin/screens/auth/login.dart';
import 'package:fashion_app_admin/screens/auth/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'inner_screen/add_prod.dart';
import 'screens/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyDGg_JhkThRgxkLazC-uTm_MYYSz4EDiBs",
      appId: "1:635160594984:web:8736b6610b0249eeb9031d",
      messagingSenderId: "635160594984",
      projectId: "fashion-app-5357d",
      storageBucket: "fashion-app-5357d.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('App is being initialized'),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('An error has been occured ${snapshot.error}'),
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              // ChangeNotifierProvider(create: (_){
              //   return ProductProvider();
              // }),
              ChangeNotifierProvider(
                create: (_) => MenuControllers(),
              ),
              ChangeNotifierProvider(
                create: (_) {
                  return themeChangeProvider;
                },
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: Styles.themeData(themeProvider.getDarkTheme, context),
                    home: const MainScreen(),
                    routes: {
                      UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                    });
              },
            ),
          );
        });
  }
}
