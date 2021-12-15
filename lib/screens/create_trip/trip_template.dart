import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Triptemplate extends StatefulWidget {
  TripTemplate triptemplate;
   Triptemplate(TripTemplate triptemplate){
    this.triptemplate=triptemplate;
  }
  @override
  _TriptemplateState createState() => _TriptemplateState(this.triptemplate);
}

class _TriptemplateState extends State<Triptemplate> {
  String tripname;
  String description;
  File Pictrip;
  File Boatpic;
  File Schedule;
  final List<String> errors = [];
  String triptype = '';
  String boatname;
  TripTemplate triptemplate;
   _TriptemplateState(TripTemplate triptemplate){
     this.triptemplate=triptemplate;
   
  }

  final TextEditingController _controllerTripname = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerBoatname = TextEditingController();

  /// Get from gallery
  _getPictrip() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        Pictrip = File(pickedFile.path);
      });
    }
  }

  _getBoatpic() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        Boatpic = File(pickedFile.path);
      });
    }
  }

  _getSchedule() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        Schedule = File(pickedFile.path);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfffd4f0f0),
      child: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(height: 20),
            buildTripNameFormField(),
            SizedBox(height: 20),
            buildDescriptionFormField(),
            SizedBox(height: 20),
            // buildBoatNameFormField(),
            // SizedBox(height: 20),
            //radio
            Row(children: [
              Text('Trip Type '),
              Spacer(),
            ]),
            Row(children: [
              Radio(
                  value: 'On shore (Hotel)',
                  groupValue: triptype,
                  onChanged: (val) {
                    triptype = val;
                    setState(() {});
                  }),
              Text('On shore (Hotel)'),
            ]),

            Row(
              children: [
                Radio(
                    value: 'Off shore (Live on boat)',
                    groupValue: triptype,
                    onChanged: (val) {
                      triptype = val;
                      setState(() {});
                    }),
                Text('Off shore (Live on boat)'),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Center(
                    child: Pictrip == null
                        ? Text('Trip image')
                        : kIsWeb
                            ? Image.network(
                                Pictrip.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(Pictrip.path),
                                fit: BoxFit.cover,
                              )),
                Spacer(),
                FlatButton(
                  color: Color(0xfffa2c8ff),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    _getPictrip();
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Center(
                    child: Boatpic == null
                        ? Text('Boat image')
                        : kIsWeb
                            ? Image.network(
                                Boatpic.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(Boatpic.path),
                                fit: BoxFit.cover,
                              )),
                Spacer(),
                FlatButton(
                  color: Color(0xfffa2c8ff),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    _getBoatpic();
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Center(
                    child: Schedule == null
                        ? Text('Schedule image')
                        : kIsWeb
                            ? Image.network(
                                Schedule.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(Schedule.path),
                                fit: BoxFit.cover,
                              )),
                Spacer(),
                FlatButton(
                  color: Color(0xfffa2c8ff),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    _getSchedule();
                  },
                ),
              ],
            ),

            // FormError(errors: errors),

            SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        triptemplate.description=value;
        print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter Description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter Description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor:  Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTripNameFormField() {
    return TextFormField(
      controller: _controllerTripname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => tripname = newValue,
      onChanged: (value) {
        print(triptemplate);
         print(triptemplate.name);

        triptemplate.name=value;
          print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter trip name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter trip name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Trip name",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildBoatNameFormField() {
    return TextFormField(
      controller: _controllerBoatname,
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
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
