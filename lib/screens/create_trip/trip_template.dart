import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io' as io;
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
  io.File Pictrip;
  io.File Boatpic;
  io.File Schedule;

  XFile pt;
  XFile bt;
  XFile sc;

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
      pt = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f = File();
    f.filename = pt.name;
    //f2.filename = 'image.jpg';
    List<int> a = await pt.readAsBytes();
    f.file = a;

    this.triptemplate.images.add(f);

    if (pt != null) {
      setState(() {
        Pictrip = io.File(pt.path);
      });
    }
  }

  _getBoatpic() async {
      bt = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f2 = File();
    f2.filename = bt.name;
    //f2.filename = 'image.jpg';
    List<int> b = await bt.readAsBytes();
    f2.file = b;

    this.triptemplate.images.add(f2);

    if (bt != null) {
      setState(() {
        Boatpic = io.File(bt.path);
      });
    }
  }

  _getSchedule() async {
      sc = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f3 = File();
    f3.filename = sc.name;
    //f2.filename = 'image.jpg';
    List<int> c = await sc.readAsBytes();
    f3.file = c;

    this.triptemplate.images.add(f3);
    if (sc != null) {
      setState(() {
        Schedule = io.File(sc.path);
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
                                io.File(Pictrip.path),
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
                                io.File(Boatpic.path),
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
                                io.File(Schedule.path),
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
