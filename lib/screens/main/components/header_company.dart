import 'package:diving_trip_agency/constants.dart';
import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/responsive.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu.dart';
import 'package:diving_trip_agency/screens/login/login.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

class HeaderCompany extends StatelessWidget {
  final MenuCompany _controller = Get.put(MenuCompany());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 150,
      // color: Color(0xfff96dfd8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            // Color(0xfffaea4e3),
            // Color(0xfffd3ffe8),
            Color(0xfffcfecd0),
            Color(0xfffffc5ca),
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
                        if (!Responsive.isDesktop(context) || MediaQuery.of(context).size.width <1232)
                        IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              _controller.openOrCloseDrawer();
                            }),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainCompanyScreen()));
                          },
                          child: Text('DivingTripAgency')),
                      Spacer(),
                      if (Responsive.isDesktop(context) && MediaQuery.of(context).size.width >1232) WebMenuCompany(),
                      Spacer(),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            //checkLogin();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xfffff8fab),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20 * 1.5, vertical: 20)),
                          child: (checkLogin())
                              ? Text("Log out",style: TextStyle(color:Colors.black),)
                              : Text("Log in",style: TextStyle(color:Colors.black),)),
                      //  (checkLogin()) ? FlatButton(child: Text("Log out")) : FlatButton(child: Text("Log in"))
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
    } on GrpcError catch (e) {
    } catch (e) {
      print('Exception: $e');
    }
  }
}
