import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Triptemplate extends StatefulWidget {
  TripTemplate triptemplate;
  Triptemplate(TripTemplate triptemplate) {
    this.triptemplate = triptemplate;
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
  String selected = null;

  Map<String, int> tripTypeMap = {};

  List<DropdownMenuItem<String>> listTrip = [];
  List<TripType> trip = [TripType.ONSHORE, TripType.OFFSHORE];

  List<String> hotel = [];
  List<String> liveaboard = [];
  List<String> triptypee = [];
  String selectedTriptype;
  String selectedsleep;

  void loadData() async {
    trip.forEach((element) {
      // print(element);
    });

    listTrip = [];
    listTrip = trip
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < TripType.values.length; i++) {
      value = TripType.valueOf(i).toString();
      tripTypeMap[value] = i;
    }
    // print(tripTypeMap);
  }

  final List<String> errors = [];
  String triptype = '';
  String boatname;
  TripTemplate triptemplate;
  _TriptemplateState(TripTemplate triptemplate) {
    this.triptemplate = triptemplate;
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

  getData() async {
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AgencyServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var hotelrequest = ListHotelsRequest();
    var liveaboardrequest = ListLiveaboardsRequest();

    try {
      // var response = await stub.listBoats(boatrequest);
      // print(token);
      // print(response);

      await for (var feature in stub.listHotels(hotelrequest)) {
      //  print(feature.hotel.name);
        hotel.add(feature.hotel.name);
      }
      await for (var feature in stub.listLiveaboards(liveaboardrequest)) {
        //print(feature.liveaboard.name);
        liveaboard.add(feature.liveaboard.name);
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    loadData();
        getData();
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
            // Row(children: [
            //   Text('Trip Type '),
            //   Spacer(),
            // ]),
            // Row(children: [
            //   Radio(
            //       value: 'On shore (Hotel)',
            //       groupValue: triptype,
            //       onChanged: (val) {
            //         // triptype = val;
            //         setState(() {
            //            triptype = val;
            //             print(val);

            //         });
            //       }),
            //   Text('On shore (Hotel)'),
            // ]),

            // Row(
            //   children: [
            //     Radio(
            //         value: 'Off shore (Live on boat)',
            //         groupValue: triptype,
            //         onChanged: (val) {
            //           // triptype = val;
            //           setState(() {
            //              triptype = val;
            //               print(val);
            //           });
            //         }),
            //     Text('Off shore (Live on boat)'),
            //   ],
            // ),

            // Container(
            //   color: Color(0xfffd4f0f0),
            //   child: Center(
            //     child: DropdownButton(
            //       isExpanded: true,
            //       value: selected,
            //       items: listTrip,
            //       hint: Text('  Select trip type'),
            //       iconSize: 40,
            //       onChanged: (value) {
            //         setState(() {
            //           selected = value;
            //           TripType.values.forEach((tripType) {
            //             if (tripTypeMap[tripType.toString()] ==
            //                 int.parse(selected)) {
            //               triptemplate.tripType = tripType;
            //             }
            //           });
            //           print(value);
            //         });
            //       },
            //     ),
            //   ),
            // ),

            DropdownButton(
              hint: Text('Trip type'),
              value: selectedTriptype,
              isExpanded: true,
              items: listTrip,
              onChanged: (trip_type) {
                // print('*');
                // print(trip_type);
                // print('*');
                // if (trip_type ==0 ) {
                //   triptypee = liveaboard;
                // } else if (trip_type == 1) {
                //   triptypee = hotel;
                // }
                // else {
                //   triptypee = [];
                // }
                if (trip_type == '0') {
                  triptypee = liveaboard;
                } else if (trip_type == '1') {
                  triptypee = hotel;
                } else {
                  // print('x');
                  // print(trip_type);
                  // print(trip_type.runtimeType);
                  triptypee = [];
                }
                setState(() {
                  // print(triptypee);
                  // print('--');
                  selectedTriptype = trip_type;
                  selectedsleep = null;
                  TripType.values.forEach((tripType) {
                    if (tripTypeMap[tripType.toString()] ==
                        int.parse(selectedTriptype)) {
                      triptemplate.tripType = tripType;
                    }
                  });
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedsleep,
              // hint: Text('Sleep'),
              isExpanded: true,
              items: triptypee.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (sleep) {
                setState(() {
                  selectedsleep = sleep;
                });
              },
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
                                width: screenwidth * 0.2,
                              )
                            : Image.file(
                                io.File(Pictrip.path),
                                fit: BoxFit.cover,
                                width: screenwidth * 0.05,
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
                                width: screenwidth * 0.2,
                              )
                            : Image.file(
                                io.File(Boatpic.path),
                                fit: BoxFit.cover,
                                width: screenwidth * 0.05,
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
                                width: screenwidth * 0.2,
                              )
                            : Image.file(
                                io.File(Schedule.path),
                                fit: BoxFit.cover,
                                width: screenwidth * 0.05,
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
              FlatButton(onPressed: getData, child: Text('check')),
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
        triptemplate.description = value;
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
        fillColor: Color(0xfffd4f0f0),
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

        triptemplate.name = value;
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
