import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens.dart/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens.dart/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldkey,
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [UserProfile()],
        ),
      ),
    );
  }
}
