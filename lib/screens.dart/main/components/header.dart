import 'package:diving_trip_agency/constants.dart';
import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/responsive.dart';
import 'package:diving_trip_agency/screens.dart/main/components/web_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  final MenuController _controller =Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: Color(0xFFF75BDFF),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              constraints: BoxConstraints(maxWidth: kMaxWidth),
              child: Column(
                children: [
                  Row(
                    children: [
                      if(!Responsive.isDesktop(context))
                      IconButton(icon: Icon(Icons.menu), 
                      onPressed: (){
                        _controller.openOrCloseDrawer();

                      }),
                      // SvgPicture.asset("assets/icons/logo.svg"),
                      Text('DivingTripAgency'),
                      Spacer(),
                      if(Responsive.isDesktop(context)) WebMenu(),
                      Spacer(),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 1.5,
                                  vertical: kDefaultPadding)),
                          child: Text("Login",
                              style: TextStyle(
                                color: Colors.black,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding * 2,
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
