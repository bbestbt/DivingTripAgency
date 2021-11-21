import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/signup/company/addStaff.dart';
import 'package:diving_trip_agency/screens/signup/company/staff_form.dart';
import 'package:flutter/material.dart';

class SignupStaff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
             height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Staff ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                     decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    child: AddMoreStaff(),
                   
                  ), SizedBox(height: 30),
                 
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainCompanyScreen()))
                    },
                    color: Color(0xfff75BDFF),
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
