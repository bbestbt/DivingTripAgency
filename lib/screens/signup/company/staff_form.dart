import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

class StaffForm extends StatefulWidget {
  String count;
  List<Staff> staffValue;
  StaffForm(String count,  List<Staff> staffValue){
    this.count=count;
    this.staffValue=staffValue;
  }
  @override
  _StaffFormState createState() => _StaffFormState(this.count,this.staffValue);
}

class _StaffFormState extends State<StaffForm> {
  String name;
  String lastname;
  String position;
  String count;
   List<Staff> staffValue;
  _StaffFormState(String count,  List<Staff> staffValue){
    this.count=count;
    this.staffValue=staffValue;
  }

  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerPosition = TextEditingController();

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
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          buildPositionFormField(),
          //   FormError(errors: errors),
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
    //      hintText: "Name",
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

  TextFormField buildPositionFormField() {
    return TextFormField(
      controller: _controllerPosition,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => position = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter staff position");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter staff position");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
     //   hintText: "Position",
        labelText: "Position",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}