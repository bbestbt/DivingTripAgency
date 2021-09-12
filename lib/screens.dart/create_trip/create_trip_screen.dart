import 'package:diving_trip_agency/screens.dart/create_trip/create_trip_form.dart';
import 'package:flutter/material.dart';

class CreateTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:50),
              Text("Create Trip ",style: TextStyle(fontSize: 20),),
              SizedBox(height: 50),
              Container(
                 width: MediaQuery.of(context).size.width/1.5,
                child: CreateTripForm()),
            ],
          ),
        ),
      ),
    );
  }
}