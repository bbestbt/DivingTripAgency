import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';

import 'package:diving_trip_agency/screens/create_trip/create_trip_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class CreateTrip extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _controller.scaffoldkey,
      drawer: CompanyHamburger(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: 600,
          // decoration: BoxDecoration(color: Color(0xfffbbdfbc).withOpacity(0.3)),
          decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Create Trip",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: CreateTripForm()),
              SizedBox(
                height: 30,
              )
              // SizedBox(
              // //  width: double.infinity,
              //   child: SingleChildScrollView(
              //     child: Container(
              //       height: MediaQuery.of(context).size.height,
              //       width: MediaQuery.of(context).size.width,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               begin: Alignment.topLeft,
              //               end: Alignment.bottomRight,
              //               colors: [
              //             Color(0xfff69b7eb),
              //             Color(0xfffb3dbd3),
              //              Color(0xffff4d6db),
              //           ])),
              //       child: SingleChildScrollView(
              //         child: Column(
              //           children: [
              //             SizedBox(height: 50),
              //             Text(
              //               "Create Trip ",
              //               style: TextStyle(fontSize: 20),
              //             ),
              //             SizedBox(height: 50),
              //             Container(
              //                 width: MediaQuery.of(context).size.width / 1.5,
              //                 decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(10)),
              //                 child: CreateTripForm()),
              //             SizedBox(
              //               height: 30,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
