import 'package:diving_trip_agency/screens/signup/company/addDiverMaster.dart';
import 'package:diving_trip_agency/screens/signup/company/divermaster_form.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';

class SignupDiveMaster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Dive Master ",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 50),
              Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: AddmoreDiverMaster()),
              SizedBox(height: 20),
              FlatButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupStaff()))
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
    );
  }
}
