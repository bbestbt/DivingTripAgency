import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/create_trip/trip_template.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:flutter/services.dart';

class CreateBoatForm extends StatefulWidget {
  @override
  _CreateBoatFormState createState() => _CreateBoatFormState();
}

class _CreateBoatFormState extends State<CreateBoatForm> {
  String boatname;
  String description;

  final List<String> errors = [];

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();



  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildBoatNameFormField(),
          SizedBox(height: 20),
          buildBoatDescriptionFormField(),
          SizedBox(height: 20),
          //   FormError(errors: errors),
          FlatButton(
            //onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))},
            onPressed: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainCompanyScreen(),
                ),
                (route) => false,
              )
            },
            color: Color(0xfff75BDFF),
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  
  TextFormField buildBoatNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => boatname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter boat name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter boat name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Boat name",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

   TextFormField buildBoatDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter boat description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter boat description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Boat description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

 
}
