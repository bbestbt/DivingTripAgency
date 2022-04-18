import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/screens/create_boat/create_boat_screen.dart';
import 'package:diving_trip_agency/screens/create_liveaboard/add_liveabord_screen.dart';
import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_screen.dart';
import 'package:diving_trip_agency/screens/main/components/navitem.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/profile/company/company_profile_screen.dart';
import 'package:diving_trip_agency/screens/report/company_report.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc.dart';
import 'package:hive/hive.dart';

import '../../login/login.dart';

class CompanyHamburger extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // color: Colors.white,
      color: Color(0xfffcfecd0),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              NavItem(
                title: 'Home',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainCompanyScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Create trip',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateTrip()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Create hotel',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HotelScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Create liveaboard',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateLiveaboardScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Create boat',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateBoat()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Create dive master',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupDiveMaster()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Create staff',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupStaff()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Profile',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyProfileScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Report',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyReportScreen()));
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
    //       color: Color(0xfffcfecd0),
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
    //                                   builder: (context) => CreateTrip()));
    //                         }
    //                         if (_controller.selectedIndex == 1) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => HotelScreen()));
    //                         }
    //                         if (_controller.selectedIndex == 2) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       CreateLiveaboardScreen()));
    //                         }
    //                         if (_controller.selectedIndex == 3) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => CreateBoat()));
    //                         }

    //                         if (_controller.selectedIndex == 4) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       SignupDiveMaster()));
    //                         }
    //                         if (_controller.selectedIndex == 5) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => SignupStaff()));
    //                         }
    //                         if (_controller.selectedIndex == 6) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       CompanyProfileScreen()));
    //                         }
    //                         if (_controller.selectedIndex == 7) {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       CompanyReportScreen()));
    //                         }

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
