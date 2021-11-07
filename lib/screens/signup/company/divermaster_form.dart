import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//ask numchok name of img
//email phn?
class DiveMasterForm extends StatefulWidget {
  String count;
  DiveMasterForm(String count) {
    this.count = count;
  }
  @override
  _DiveMasterFormState createState() => _DiveMasterFormState(this.count);
}

class _DiveMasterFormState extends State<DiveMasterForm> {
  bool _isObscure = true;
  String name;
  String lastname;
  String email;
  String phoneNumber;
  File CardFile;

  File CardFileBack;
  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  _DiveMasterFormState(String count);

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

  // void addDiverMaster() {
  //   final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
  //       host: '139.59.101.136',
  //       grpcPort: 50051,
  //       grpcTransportSecure: false,
  //       grpcWebPort: 8080,
  //       grpcWebTransportSecure: false);

  //   final stub = AgencyServiceClient(channel);
  //   var diveMaster = DiveMaster();
  //   diveMaster.firstName = _controllerName.text;
  //   diveMaster.lastName = _controllerLastname.text;

  //   var diveMasterRequest = AddDiveMasterRequest();
  //   //
  //   diveMasterRequest.diveMaster=diveMaster;

  //   try {
  //     //
  //     var response = stub.addDiveMaster(diveMasterRequest);
  //     print('response: ${response}');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          buildEmailFormField(),
          SizedBox(height: 20),
          buildPhoneNumberFormField(),
          SizedBox(height: 20),
          //doc
          //   FormError(errors: errors),
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
      cursorColor: Color(0xFF6F35A5),
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
      cursorColor: Color(0xFF6F35A5),
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
