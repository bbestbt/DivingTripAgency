import 'package:diving_trip_agency/constants.dart';
import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/responsive.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartScreen.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/forecast_screen.dart';
import 'package:diving_trip_agency/screens/main/components/navitem.dart';
import 'package:diving_trip_agency/screens/main/components/responsive.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu.dart';
import 'package:diving_trip_agency/screens/login/login.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/profile/diver/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 100,
        // color: Color(0xFFF75BDFF),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xfffb9deed),
              Color(0xfffefefef),
            ])),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text('DivingTripAgency'),
            Spacer(),
            if (!isMobile(context))
              Row(
                children: [
                  NavItem(
                    title: 'Home',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Trips',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TripDetailScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Weather Forecast',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WForecastScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Profile',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Cart',
                    tapEvent: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ShopCart()));
                    },
                  ),
                  Container(
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20 * 1.5, vertical: 20)),
                        // child: Text("Login",
                        // style: TextStyle(
                        // color: Colors.black,
                        // ))
                        child: (checkLogin())
                            ? Text(
                                "Log out",
                                style: TextStyle(color: Colors.black),
                              )
                            : Text(
                                "Log in",
                                style: TextStyle(color: Colors.black),
                              )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            if (isMobile(context))
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  })
          ],
        ));
  }

  bool checkLogin() {
    try {
      var box = Hive.box('userInfo');
      Hive.openBox('userInfo');
      String token = box.get('token');
      bool login = box.get('login');
      if (login == true) {
        print(login);
        return true;
      } else {
        print(login);
        return false;
      }
    } on GrpcError catch (e) {
    } catch (e) {
      print('Exception: $e');
    }
  }
}
