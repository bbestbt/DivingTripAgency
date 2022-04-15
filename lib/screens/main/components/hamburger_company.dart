import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/screens/create_boat/create_boat_screen.dart';
import 'package:diving_trip_agency/screens/create_liveaboard/add_liveabord_screen.dart';
import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_screen.dart';
import 'package:diving_trip_agency/screens/main/components/navitem.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/profile/company/company_profile_screen.dart';
import 'package:diving_trip_agency/screens/report/company_report.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyHamburger extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              NavItem(
                title: 'Create trip',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateTrip()));
                },
              ),
              NavItem(
                title: 'Create hotel',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HotelScreen()));
                },
              ),
              NavItem(
                title: 'Create liveaboard',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateLiveaboardScreen()));
                },
              ),
              NavItem(
                title: 'Create boat',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateBoat()));
                },
              ),
              NavItem(
                title: 'Create dive master',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupDiveMaster()));
                },
              ),
              NavItem(
                title: 'Create staff',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupStaff()));
                },
              ),
              NavItem(
                title: 'Profile',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyProfileScreen()));
                },
              ),
              NavItem(
                title: 'Report',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyReportScreen()));
                },
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
}
