import 'package:flutter/material.dart';

class StaffForm extends StatefulWidget {
  String count;
  StaffForm(String count){
    this.count=count;
  }
  @override
  _StaffFormState createState() => _StaffFormState(this.count);
}

class _StaffFormState extends State<StaffForm> {
  String name;
  String lastname;
  String position;
  String count;
  _StaffFormState(String count){
    this.count=count;
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
          hintText: "Name",
          labelText: "First Name",
          filled: true,
          fillColor: Color(0xFFFd0efff),
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
          hintText: "Lastname",
          labelText: "Last Name",
          filled: true,
          fillColor: Color(0xFFFd0efff),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildPositionFormField() {
    return TextFormField(
      controller: _controllerPosition,
      cursorColor: Color(0xFF6F35A5),
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
        hintText: "Position",
        labelText: "Position",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
