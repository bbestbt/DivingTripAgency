import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';


class TripDetailScreen extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldkey,
      drawer: SideMenu(),
      body: SingleChildScrollView(child:
        Column(
        children: [
          Header(),
          // SizedBox(height: 20),
         TripDetail()
        ],
      ),
      )
    );
  }
}
