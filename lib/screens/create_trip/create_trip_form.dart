import 'package:diving_trip_agency/screens/create_trip/trip_template.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateTripForm extends StatefulWidget {
  @override
  _CreateTripFormState createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  // String place;
  String from;
  String to;
  String divemastername;
  String price;
  String totalpeople;

  final List<String> errors = [];

  //final TextEditingController _controllerPlace = TextEditingController();
  final TextEditingController _controllerFrom = TextEditingController();
  final TextEditingController _controllerTo = TextEditingController();
  final TextEditingController _controllerDivemastername =
      TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerTotalpeople = TextEditingController();
  
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
          // buildPlaceFormField(),
          // SizedBox(height: 20),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildFromFormField()),
              // SizedBox(width: 20),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildToFormField()),
            ],
          ),
          SizedBox(height: 20),
          buildDiveMasterNameFormField(),
          SizedBox(height: 20),
          buildPriceFormField(),
          SizedBox(height: 20),
          buildTotalPeopleFormField(),
          SizedBox(height: 20),
           Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Triptemplate()),
        
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

  // TextFormField buildPlaceFormField() {
  //   return TextFormField(
  //     controller: _controllerPlace,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => place = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please Enter place");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please Enter place");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Place",
  //       filled: true,
  //       fillColor: Colors.white,
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  TextFormField buildFromFormField() {
    return TextFormField(
      controller: _controllerFrom,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => from = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "From");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "From");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "From",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildToFormField() {
    return TextFormField(
      controller: _controllerTo,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => to = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "To");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "To");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "To",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDiveMasterNameFormField() {
    return TextFormField(
      controller: _controllerDivemastername,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => divemastername = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter dive master name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter dive master name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Dive master name",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: _controllerPrice,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => price = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter price");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter price");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTotalPeopleFormField() {
    return TextFormField(
      controller: _controllerTotalpeople,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => totalpeople = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter total people");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter total people");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Total people",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  
}
