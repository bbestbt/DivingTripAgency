import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment.dart';
import 'package:diving_trip_agency/screens/profile/diver/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  int reservation_id;
  @override
  PaymentScreen(int reservation_id) {
    this.reservation_id = reservation_id;
  }
  State<PaymentScreen> createState() => _PaymentScreenState(this.reservation_id);
}

class _PaymentScreenState extends State<PaymentScreen> {
  int reservation_id;

  final MenuController _controller = Get.put(MenuController());
_PaymentScreenState(this.reservation_id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldkey,
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [Header(), 
          PaymentUpload(reservation_id)
          ],
        ),
      ),
    );
  }
}
