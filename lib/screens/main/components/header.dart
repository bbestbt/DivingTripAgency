import 'package:diving_trip_agency/constants.dart';
import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/responsive.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu.dart';
import 'package:diving_trip_agency/screens/login/login.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 150,
      // color: Color(0xFFF75BDFF),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            // Color(0xfffa2e1db),
            //  Color(0xfffabdee6)
            Color(0xfff78c5dc),
            Color(0xfff97dee7),
            Color(0xfffb7ecea),
            Color(0xfffd8f4ef),
            //   Color(0xffff0fdfa),
            Color(0xfffc5f7eb),
          ])),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(maxWidth: 1232),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (!Responsive.isDesktop(context))
                        IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              _controller.openOrCloseDrawer();
                            }),
                      // SvgPicture.asset("assets/icons/logo.svg"),
                      FlatButton(
                        onPressed:() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                          }, child: Text('DivingTripAgency')),
                      Spacer(),
                      if (Responsive.isDesktop(context)) WebMenu(),
                      Spacer(),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20 * 1.5, vertical: 20)),
                          child: Text("Login",
                              style: TextStyle(
                                color: Colors.black,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // Text(
                  //   "Welcome",
                  //   style: TextStyle(
                  //       fontSize: 32,
                  //       color: Color(0xfff281E5D),
                  //       fontWeight: FontWeight.bold),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
