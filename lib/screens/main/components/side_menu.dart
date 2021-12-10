import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/Booking/divingshop_screen.dart';
import 'package:diving_trip_agency/screens/aboutus/aboutus_screen.dart';
import 'package:diving_trip_agency/screens/detail/package_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/dive_resort_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_screen.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: Color(0xfffb9deed),
          child: Obx(
            () => ListView(
              children: [
                DrawerHeader(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("DivingTrip"),
                )),
                //  DrawerItem()
                ...List.generate(
                    _controller.menuItems.length,
                    (index) => DrawerItem(
                          isActive: index == _controller.selectedIndex,
                          title: _controller.menuItems[index],
                          press: () {
                            _controller.setMenuIndex(index);
                            if (_controller.selectedIndex == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen()));
                            }
                            if (_controller.selectedIndex == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LiveaboardScreen()));
                            }
                            if (_controller.selectedIndex == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DiveResortScreen()));
                            }
                            if (_controller.selectedIndex == 3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PackageScreen()));
                            }
                            if (_controller.selectedIndex == 4) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutusScreen()));
                            }
                            if (_controller.selectedIndex == 5) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DivingshopScreen()));
                            }
                          },
                        ))
              ],
            ),
          )),
    );
  }
}
