import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/Booking/divingshop_screen.dart';
import 'package:diving_trip_agency/screens/aboutus/aboutus_screen.dart';
import 'package:diving_trip_agency/screens/detail/package_screen.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/dive_resort_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_screen.dart';
import 'package:diving_trip_agency/screens/main/components/navitem.dart';
import 'package:diving_trip_agency/screens/profile/diver/profile_screen.dart';
import 'package:diving_trip_agency/screens/review/Reviewscreen.dart';
import 'package:diving_trip_agency/screens/weatherforecast/forecast_screen.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartScreen.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc.dart';
import 'package:hive/hive.dart';

import '../../login/login.dart';


class SideMenu extends StatelessWidget {
  // final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // color: Colors.white,
       color: Color(0xfffb9deed),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              NavItem(
                title: 'Home',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Trips',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripDetailScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Reviews',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Weather Forecast',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WForecastScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Profile',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Cart',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShopCart()));
                },
              ),
              SizedBox(height: 20),
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



            ],
          ),
        ),
      ),
    );


    // return Drawer(
    //   child: Container(
    //       color: Color(0xfffb9deed),
    //       child: Obx(
    //         () => ListView(
    //           children: [
    //             DrawerHeader(
    //                 child: Padding(
    //               padding: const EdgeInsets.all(8),
    //               child: Text("DivingTrip"),
    //             )),
    //             //  DrawerItem()
    //             ...List.generate(
    //                 _controller.menuItems.length,
    //                 (index) => DrawerItem(
    //                       isActive: index == _controller.selectedIndex,
    //                       title: _controller.menuItems[index],
    //                       press: () {
    //                         _controller.setMenuIndex(index);
    //                         if (_controller.selectedIndex == 0) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => MainScreen()));
    //                         }
    //                                if (_controller.selectedIndex == 1) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       TripDetailScreen()));
    //                         }
    //                         // if (_controller.selectedIndex == 1) {
    //                         //   Navigator.push(
    //                         //       context,
    //                         //       MaterialPageRoute(
    //                         //           builder: (context) =>
    //                         //               LiveaboardScreen()));
    //                         // }
    //                         // if (_controller.selectedIndex == 2) {
    //                         //   Navigator.push(
    //                         //       context,
    //                         //       MaterialPageRoute(
    //                         //           builder: (context) =>
    //                         //               DiveResortScreen()));
    //                         // }
    //                         // if (_controller.selectedIndex == 3) {
    //                         //   Navigator.push(
    //                         //       context,
    //                         //       MaterialPageRoute(
    //                         //           builder: (context) => PackageScreen()));
    //                         // }
    //                         if (_controller.selectedIndex == 2) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => WForecastScreen()));
    //                         }
    //                          if (_controller.selectedIndex == 3) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => UserProfileScreen()));
    //                         }
    //                         if (_controller.selectedIndex == 4) {
    //                           print("Shopping cart");
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       ShopCart()));
    //                         }

    //                         // if (_controller.selectedIndex == 5) {
    //                         //   Navigator.push(
    //                         //       context,
    //                         //       MaterialPageRoute(
    //                         //           builder: (context) => AboutusScreen()));
    //                         // }
    //                         // if (_controller.selectedIndex == 6) {
    //                         //   Navigator.push(
    //                         //       context,
    //                         //       MaterialPageRoute(
    //                         //           builder: (context) =>
    //                         //               DivingshopScreen()));
    //                         // }
    //                       },
    //                     ))
    //           ],
    //         ),
    //       )),
    // );


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
    } on GrpcError catch (e) {} catch (e) {
      print('Exception: $e');
    }
  }
}
