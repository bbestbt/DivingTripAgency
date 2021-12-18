import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/create_trip/trip_template.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:flutter/services.dart';

class CreateTripForm extends StatefulWidget {
  
  @override
  _CreateTripFormState createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  // String place;
  String divemastername;
  String price;
  String totalpeople;
  
  final List<String> errors = [];
  List<DropdownMenuItem<String>> listDivemaster = [];
  List<String> divemaster = ['boss', 'mon', 'numchok'];
  String divemasterSelected;
  List<DropdownMenuItem<String>> listBoat = [];
  List<String> boat = ['b1', 'b2'];
  String boatSelected;

  TripTemplate triptemplate = new TripTemplate();
 

  //final TextEditingController _controllerPlace = TextEditingController();
  final TextEditingController _controllerFrom = TextEditingController();
  final TextEditingController _controllerTo = TextEditingController();
  final TextEditingController _controllerDivemastername =
      TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerTotalpeople = TextEditingController();

  DateTimeRange dateRange;
  DateTime from;
  DateTime to;


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

    void loadData() {
    listBoat = [];
    listBoat = boat
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();

    listDivemaster = [];
    listDivemaster = divemaster
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();
    
  }


  void AddTrip() async{
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
        final box = Hive.box('userInfo');

        String token = box.get('token');

    final stub = AgencyServiceClient(channel,options: CallOptions(metadata:{'Authorization':  '$token'}));
    var trip = Trip();
    trip.from = Timestamp.fromDateTime(from);
    trip.to = Timestamp.fromDateTime(to);
    trip.maxCapacity = int.parse(_controllerTotalpeople.text);
    trip.price= double.parse(_controllerPrice.text);

    var tripRequest = AddTripRequest();
    tripRequest.trip = trip;
    tripRequest.tripTemplate=triptemplate;
    //tripRequest.tripTemplate.images.add(value);


    //try {
      //var response = stub.addTrip(tripRequest);
      //print('response: ${response}');
    //} catch (e) {
      //print(e);
    //}
  //}
    print(tripRequest);
    try {
      var response = await stub.addTrip(tripRequest);
      print(token);
      print(response);

    } on GrpcError catch (e) {
      // Handle exception of type GrpcError
      print('codeName: ${e.codeName}');
      print('details: ${e.details}');
      print('message: ${e.message}');
      print('rawResponse: ${e.rawResponse}');
      print('trailers: ${e.trailers}');
    } catch (e) {
      // Handle all other exceptions
      print('Exception: $e');
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
          Row(
            children: [
              Text('From'),
              Spacer(),
             //  Text(from == null ? '' : from.toString()),
              Spacer(),
              RaisedButton(
                  color: Color(0xfff8dd9cc),
                  child: Text('Pick a date'),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2023))
                        .then((date) => {
                              setState(() {
                                var timeStamp =
                                    print(Timestamp.fromDateTime(date));
                                from = date;
                              })
                            });
                  }),
            ],
          ),
           SizedBox(height: 20),
        Row(
            children: [
              Text('To'),
              Spacer(),
              // Text(to == null ? '' : to.toString()),
              Spacer(),
              RaisedButton(
                  color: Color(0xfff8dd9cc),
                  child: Text('Pick a date'),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2023))
                        .then((date) => {
                              setState(() {
                                var timeStamp =
                                    print(Timestamp.fromDateTime(date));
                                to = date;
                              })
                            });
                  }),
            ],
          ),
          SizedBox(height: 20),
          // buildDiveMasterNameFormField(),
         
          Container(
            color: Colors.white,
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: divemasterSelected,
                items: listDivemaster,
                hint: Text('  Select dive master'),
                iconSize: 40,
                onChanged: (value) {
                  setState(() {
                    divemasterSelected = value;
                    print(value);
                  });
                },
              ),
            ),
          ),
           SizedBox(height: 20),
            Container(
            color: Colors.white,
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: boatSelected,
                items: listBoat,
                hint: Text('  Select boat'),
                iconSize: 40,
                onChanged: (value) {
                  setState(() {
                    boatSelected = value;
                    print(value);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          buildPriceFormField(),
          SizedBox(height: 20),
          buildTotalPeopleFormField(),
          SizedBox(height: 20),
          Container(
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Triptemplate(this.triptemplate)),

          SizedBox(height: 20),
          //   FormError(errors: errors),
          FlatButton(
            //onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))},
            onPressed: () => {
              AddTrip(),
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
          //  FlatButton(
          //   onPressed: () => {
          //     // print(pinkValue),
          //     //  print('------------'),
          //     print(triptemplate.name),
          //       print(triptemplate.description),

          //   },
          //   color: Color(0xfff75BDFF),
          //   child: Text(
          //     'check',
          //     style: TextStyle(fontSize: 15),
          //   ),
          // ),
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

  // TextFormField buildFromFormField() {
  //   return TextFormField(
  //     controller: _controllerFrom,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => from = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "From");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "From");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "From",
  //       filled: true,
  //       fillColor: Colors.white,
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  // TextFormField buildToFormField() {
  //   return TextFormField(
  //     controller: _controllerTo,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => to = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "To");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "To");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "To",
  //       filled: true,
  //       fillColor: Colors.white,
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

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
       keyboardType: TextInputType.number,
    inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
      keyboardType: TextInputType.number,
    inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
