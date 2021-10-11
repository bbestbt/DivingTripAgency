import 'package:diving_trip_agency/screens/signup/diver/diver_form.dart';
import 'package:flutter/material.dart';

class SignUpDiverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:50),
              Text("Register account (Diver) ",style: TextStyle(fontSize: 20),),
              Text(
                "Complete your details",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Container(
                 width: MediaQuery.of(context).size.width/1.5,
                child: SignupDiverForm()),
            ],
          ),
        ),
      ),
    );
  }
}
