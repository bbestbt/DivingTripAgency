import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addRoom.dart';

import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class addLiveaboard extends StatefulWidget {
  List<String> errors = [];
  addLiveaboard(List<String> errors) {
    this.errors = errors;
  }
  @override
  _addLiveaboardState createState() => _addLiveaboardState(this.errors);
}

class _addLiveaboardState extends State<addLiveaboard> {
  String liveaboard_name;
  String liveaboard_description;
  String length;
  String width;
  String staff_room;
  String diver_room;
  String total_capacity;
  String address1;
  String address2;
  String postalCode;
  String country;
  String region;
  String city;

  io.File liveaboardimg;
  io.File liveaboardimg2;
  io.File liveaboardimg3;
  io.File liveaboardimg4;
  io.File liveaboardimg5;
  io.File liveaboardimg6;
  io.File liveaboardimg7;
  io.File liveaboardimg8;
  io.File liveaboardimg9;
  io.File liveaboardimg10;
  var liveaboard = Liveaboard();
  XFile lvb;
  XFile rroom;

  List<RoomType> pinkValue = [new RoomType()];
  List<List<Amenity>> blueValue = [
    [new Amenity()]
  ];
  _addLiveaboardState(this.errors);
  List<String> errors = [];
  final TextEditingController _controllerLiveaboardname =
      TextEditingController();
  final TextEditingController _controllerLiveaboarddescription =
      TextEditingController();
  final TextEditingController _controllerLength = TextEditingController();
  final TextEditingController _controllerWidth = TextEditingController();
  final TextEditingController _controllerStaffroom = TextEditingController();
  final TextEditingController _controllerDiverroom = TextEditingController();
  final TextEditingController _controllerTotalcapacity =
      TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerAddress2 = TextEditingController();
  final TextEditingController _controllerPostalcode = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerRegion = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> countryName = [
    'Thailand',
    'Korea',
    'Japan',
    'England',
    'Hongkong'
  ];
  String countrySelected;
  List<DropdownMenuItem<String>> listCountry = [];

  List<String> regionName = [
    'Asia',
    'Americas',
    'Africa',
    'Western Europe',
    'Central and Eastern Europe',
    'Mediterranean and Middle East'
  ];
  String regionSelected;
  List<DropdownMenuItem<String>> listRegion = [];
  void listDetail() {
    listCountry = [];
    listCountry = countryName
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();

    listRegion = [];
    listRegion = regionName
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
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

  void sendLiveaboard() async {
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

    liveaboard.name = _controllerLiveaboardname.text;
    liveaboard.description = _controllerLiveaboarddescription.text;
    liveaboard.width = double.parse(_controllerWidth.text);
    liveaboard.length = double.parse(_controllerLength.text);
    liveaboard.totalCapacity = int.parse(_controllerTotalcapacity.text);
    liveaboard.staffRooms = int.parse(_controllerStaffroom.text);
    liveaboard.diverRooms = int.parse(_controllerDiverroom.text);

    var address = Address();
    address.addressLine1 = _controllerAddress.text;
    address.addressLine2 = _controllerAddress2.text;
    address.city = _controllerCity.text;
    address.postcode = _controllerPostalcode.text;
    address.region = regionSelected;
    address.country = countrySelected;
    liveaboard.address = address;



    for (int i = 0; i < pinkValue.length; i++) {
      var room = RoomType();
      for (int j = 0; j < blueValue[i].length; j++) {
        var amenity = Amenity();
        amenity.name = blueValue[i][j].name;
        amenity.id = blueValue[i][j].id;
        // amenity.description = blueValue[i][j].description;
        room.amenities.add(amenity);
      }
      room.name = pinkValue[i].name;
      room.description = pinkValue[i].description;
      room.maxGuest = pinkValue[i].maxGuest;
      room.price = pinkValue[i].price;
      room.quantity = pinkValue[i].quantity;
      //room.roomImages.add(f2);
      //pinkValue[i].roomImages.add(value);
      for (int j = 0; j < pinkValue[i].roomImages.length; j++) {
        room.roomImages.add(pinkValue[i].roomImages[j]);
      }
      liveaboard.roomTypes.add(room);
    }

    var liveaboardRequest = AddLiveaboardRequest();
    liveaboardRequest.liveaboard = liveaboard;
    try {
      var response = await stub.addLiveaboard(liveaboardRequest);
      print(token);
      print(response);
      print('response: ${response}');
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

  // get hotel image
  _getliveaboard(int num) async {
    lvb = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    var f = File();
    f.filename = lvb.name;
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await lvb.readAsBytes();
    f.file = b;
    liveaboard.images.add(f);

    if (lvb != null) {
      setState(() {
        if (num == 1) liveaboardimg = io.File(lvb.path);
        if (num == 2) liveaboardimg2 = io.File(lvb.path);
        if (num == 3) liveaboardimg3 = io.File(lvb.path);
        if (num == 4) liveaboardimg4 = io.File(lvb.path);
        if (num == 5) liveaboardimg5 = io.File(lvb.path);
        if (num == 6) liveaboardimg6 = io.File(lvb.path);
        if (num == 7) liveaboardimg7 = io.File(lvb.path);
        if (num == 8) liveaboardimg8 = io.File(lvb.path);
        if (num == 9) liveaboardimg9 = io.File(lvb.path);
        if (num == 10) liveaboardimg10 = io.File(lvb.path);
        //liveaboardimg = io.File(lvb.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    listDetail();
    double screenwidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildHotelNameFormField(),
          SizedBox(height: 20),
          buildHotelDescriptionFormField(),
          SizedBox(height: 20),
          buildLengthFormField(),
          SizedBox(height: 20),
          buildWidthFormField(),
          SizedBox(height: 20),
          buildAddressFormField(),
          SizedBox(height: 20),
          buildAddress2FormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.6,
                color: Colors.white,
                child: Center(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: countrySelected,
                    items: listCountry,
                    hint: Text('  Select country'),
                    iconSize: 40,
                    validator: (value) {
                      if (value == null) {
                        addError(error: "Please select country");
                        return "";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        removeError(error: "Please select country");
                        setState(() {
                          countrySelected = value;
                          print(value);
                        });
                      }
                    },
                  ),
                ),
              ),
              // Container(
              //     width: MediaQuery.of(context).size.width / 3.6,
              //     child: buildCountryFormField()),
              Spacer(),
              // Spacer(flex: 1,),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildCityFormField()),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.6,
                color: Colors.white,
                child: Center(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: regionSelected,
                    items: listRegion,
                    hint: Text('  Select region'),
                    iconSize: 40,
                    validator: (value) {
                      if (value == null) {
                        addError(error: "Please select region");
                        return "";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        removeError(error: "Please select region");
                        setState(() {
                          regionSelected = value;
                          print(value);
                        });
                      }
                    },
                  ),
                ),
              ),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildPostalCodeFormField()),
            ],
          ),
          SizedBox(height: 20),
          buildTotalCapacityFormField(),
          SizedBox(height: 20),
          buildDiverRoomFormField(),
          SizedBox(height: 20),
          buildStaffRoomFormField(),
          SizedBox(height: 20),

          //Text('Hotel Image'),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(1);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg2 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg2.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg2.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(2);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg3 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg3.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg3.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(3);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg4 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg4.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg4.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(4);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg5 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg5.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg5.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(5);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg6 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg6.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg6.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(6);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg7 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg7.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg7.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(7);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg8 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg8.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg8.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(8);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg9 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg9.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg9.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(9);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: liveaboardimg10 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              liveaboardimg10.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg10.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getliveaboard(10);
                },
              ),
            ],
          ),
          SizedBox(height: 20),

          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xffffee1e8),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreRoom(this.pinkValue, this.blueValue, this.errors),
          ),
          SizedBox(height: 30),
          FormError(errors: errors),
          FlatButton(
            onPressed: () => {
              if (_formKey.currentState.validate())
                {
                  if (liveaboardimg == null)
                    {
                      addError(error: "Please upload image"),
                    }
                  else
                    {
                      sendLiveaboard(),
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MainCompanyScreen(),
                        ),
                        (route) => false,
                      )
                    }
                }
            },
            color: Color(0xfff75BDFF),
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 15),
            ),
          ),

          // FlatButton(
          //   onPressed: () => {
          //     // print(pinkValue),
          //     //  print('------------'),
          //     print(blueValue),
          //   },
          //   color: Color(0xfff75BDFF),
          //   child: Text(
          //     'check',
          //     style: TextStyle(fontSize: 15),
          //   ),
          // ),

          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildHotelNameFormField() {
    return TextFormField(
      controller: _controllerLiveaboardname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => liveaboard_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter liveaboard name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter liveaboard name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Liveaboard name",
        filled: true,
        //fillColor: Color(0xFFFd0efff),
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildHotelDescriptionFormField() {
    return TextFormField(
      controller: _controllerLiveaboarddescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => liveaboard_description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter liveaboard description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter liveaboard description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Liveaboard description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLengthFormField() {
    return TextFormField(
      controller: _controllerLength,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => length = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter length");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter length");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Length",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildWidthFormField() {
    return TextFormField(
      controller: _controllerWidth,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => liveaboard_description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter width");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter width");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Width",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildStaffRoomFormField() {
    return TextFormField(
      controller: _controllerStaffroom,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => staff_room = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter number of staff room");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter number of staff room");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Number of staff room",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDiverRoomFormField() {
    return TextFormField(
      controller: _controllerDiverroom,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => diver_room = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter number of diver room");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter number of diver room");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Number of diver room",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTotalCapacityFormField() {
    return TextFormField(
      controller: _controllerTotalcapacity,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => total_capacity = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter total capacity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter total capacity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Total capacity",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //    hintText: "Address1",
          labelText: "Address 1",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildAddress2FormField() {
    return TextFormField(
      controller: _controllerAddress2,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address2 = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //   hintText: "Address2",
          labelText: "Address 2",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      controller: _controllerCountry,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter country");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter country");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Country",
        labelText: "Country",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      controller: _controllerCity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter city");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter city");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "City",
        labelText: "City",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRegionFormField() {
    return TextFormField(
      controller: _controllerRegion,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => region = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter region");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter region");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //    hintText: "Region",
        labelText: "Region",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPostalCodeFormField() {
    return TextFormField(
      controller: _controllerPostalcode,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => postalCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter postal code");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter postal code");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Postal code",
        labelText: "Postal code",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
