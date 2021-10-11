import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldkey,
      drawer: SideMenu(),
      body: ListViewTripDetail(),
    );
  }
}
