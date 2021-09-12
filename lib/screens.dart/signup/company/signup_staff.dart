import 'package:diving_trip_agency/screens.dart/signup/company/addStaff.dart';
import 'package:diving_trip_agency/screens.dart/signup/company/staff_form.dart';
import 'package:flutter/material.dart';
import 'package:diving_trip_agency/screens.dart/main/mainScreen.dart';
import 'package:diving_trip_agency/screens.dart/create_trip/create_trip_screen.dart';
class SignupStaff extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
       body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:50),
              Text("Staff ",style: TextStyle(fontSize: 20),),
              SizedBox(height: 50),
              Container(
                 width: MediaQuery.of(context).size.width/1.5,
                child: AddMoreStaff(),
                ),
                 SizedBox(height: 20),
          FlatButton(
            onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTrip()))},
            color: Color(0xfff75BDFF),
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 15),
            ),
          )

            ],
          ),
        ),
      ),
      
    );
  }
}