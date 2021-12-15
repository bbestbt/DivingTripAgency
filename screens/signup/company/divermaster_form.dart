import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pbenum.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DiveMasterForm extends StatefulWidget {
  String count;
  List<DiveMaster> divemasterValue;
  DiveMasterForm(String count,List<DiveMaster> divemasterValue) {
    this.divemasterValue=divemasterValue;
    this.count = count;
  }
  @override
  _DiveMasterFormState createState() => _DiveMasterFormState(this.count,this.divemasterValue);
}

class _DiveMasterFormState extends State<DiveMasterForm> {
  bool _isObscure = true;
  String name;
  String lastname;
  String email;
  String phoneNumber;
  File CardFile;
  String levelSelected = null;
  List<DiveMaster> divemasterValue;
  String count;
  File CardFileBack;
  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  _DiveMasterFormState(String count,this.divemasterValue){
    this.count=count;
    this.divemasterValue=divemasterValue;
  }

  List<DropdownMenuItem<String>> listLevel = [];
  List<LevelType> level = [
    LevelType.MASTER,
    LevelType.OPEN_WATER,
    LevelType.RESCUE,
    LevelType.INSTRUCTOR,
    LevelType.ADVANCED_OPEN_WATER
  ];

  void loadData() {
    level.forEach((element) {
      print(element);
    });
    listLevel = [];
    listLevel = level
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();
  }

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

  _getCard() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        CardFile = File(pickedFile.path);
      });
    }
  }

  _getCardBack() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        CardFileBack = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
           Container(
            color: Colors.white,
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: levelSelected,
                items: listLevel,
                hint: Text('  Select level'),
                iconSize: 40,
                onChanged: (value) {
                  setState(() {
                    levelSelected = value;
                    print(value);
                  });
                },
              ),
            ),
          ),
          // buildEmailFormField(),
          // SizedBox(height: 20),
          // buildPhoneNumberFormField(),
          SizedBox(height: 20),
          FormError(errors: errors),
          Row(
            children: [
              Column(
                children: [Text("Divemaster Card"), Text('(Front)')],
              ),
              Center(
                  child: CardFile == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              CardFile.path,
                              fit: BoxFit.cover,
                              width: 300,
                            )
                          : Image.file(
                              File(CardFile.path),
                              fit: BoxFit.cover,
                              width: 300,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getCard();
                },
              ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Column(
                children: [Text("Divemaster Card"), Text("(Back)")],
              ),
              Center(
                  child: CardFileBack == null
                      ? Column(
                          children: [
                            //Text('Divemaster Card '),
                            // Text('(Back)')
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              CardFileBack.path,
                              fit: BoxFit.cover,
                              width: 300,
                            )
                          : Image.file(
                              File(CardFileBack.path),
                              fit: BoxFit.cover,
                              width: 300,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getCardBack();
                },
              ),
            ],
          ),

          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter your name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //  hintText: "Name",
          labelText: "First Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
      controller: _controllerLastname,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lastname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your lastname");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter your lastname");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //    hintText: "Lastname",
          labelText: "Last Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your email");
        } else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          removeError(error: "Please Enter Valid Email");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter your email");
          return "";
        } else if (!(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
            .hasMatch(value)) {
          addError(error: "Please Enter Valid Email");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        //  hintText: "Email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.mail),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your phone number");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter your phone number");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        //     hintText: "Phone number",
        labelText: "Phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }
}
