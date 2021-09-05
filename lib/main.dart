import 'package:diving_trip_agency/screens.dart/login/login.dart';
import 'package:diving_trip_agency/screens.dart/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //for state management
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diving Trip Agency',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBgColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(backgroundColor: Color(0xFFF52B2Bf)),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kBodyTextColor),
          bodyText2: TextStyle(color: kBodyTextColor),
          headline5: TextStyle(color: kDarkBlackColor),
        ),
        fontFamily: 'Poppins'
      ),
      //home: LoginScreen(),
      home: MainScreen(), //Original
    );
  }
}