import 'package:diving_trip_agency/screens.dart/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens.dart/login/login.dart';
import 'package:diving_trip_agency/screens.dart/main/mainScreen.dart';
import 'package:diving_trip_agency/screens.dart/profile/profile_screen.dart';
import 'package:diving_trip_agency/screens.dart/signup/company/signup_company.dart';
import 'package:diving_trip_agency/screens.dart/signup/company/signup_divemaster.dart';
import 'package:diving_trip_agency/screens.dart/signup/company/signup_staff.dart';
import 'package:diving_trip_agency/screens.dart/signup/diver/signup_diver.dart';
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(backgroundColor: Color(0xFFF52B2Bf)),
        ),
        fontFamily: 'Poppins'
      ),
     // home: LoginScreen(),
    //home:ProfileScreen()
     home: MainScreen(), //Original
    );
  }
}