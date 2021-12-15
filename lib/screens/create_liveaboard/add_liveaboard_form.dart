import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/hotel/addRoom.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/hotel/highlight.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
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

//img
class addLiveaboard extends StatefulWidget {
  @override
  _addLiveaboardState createState() => _addLiveaboardState();
}

class _addLiveaboardState extends State<addLiveaboard> {
  String liveaboard_name;
  String liveaboard_description;
  String length;
  String width;
  io.File liveaboardimg;

  PickedFile lvb;
  PickedFile rroom;

  List<RoomType> pinkValue = [new RoomType()];
  List<List<Amenity>> blueValue = [
    [new Amenity()]
  ];

  final List<String> errors = [];
  final TextEditingController _controllerLiveaboardname =
      TextEditingController();
  final TextEditingController _controllerLiveaboarddescription =
      TextEditingController();
  final TextEditingController _controllerLength = TextEditingController();
  final TextEditingController _controllerWidth = TextEditingController();

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
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AgencyServiceClient(
      channel,
    );
    var liveaboard = Liveaboard();
    liveaboard.name = _controllerLiveaboardname.text;
    liveaboard.description = _controllerLiveaboarddescription.text;
    liveaboard.width = int.parse(_controllerWidth.text);
    liveaboard.length = int.parse(_controllerLength.text);

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await lvb.readAsBytes();
    f.file = b;
    liveaboard.images.add(f);

    var f2 = File();
    f2.filename = 'Image.jpg';
    List<int> a = await rroom.readAsBytes();
    f2.file = a;

    var room = RoomType();
    var amenity = Amenity();
    for (int i = 0; i < pinkValue.length; i++) {
      room.name = pinkValue[i].name;
      room.description = pinkValue[i].description;
      room.maxGuest = pinkValue[i].maxGuest;
      room.price = pinkValue[i].price;
      room.quantity = pinkValue[i].quantity;
      room.roomImages.add(f2);
      liveaboard.roomTypes.add(room);
      for (int j = 0; j < blueValue.length; j++) {
        amenity.name = blueValue[i][j].name;
        amenity.description = blueValue[i][j].description;
        room.amenities.add(amenity);
      }
    }

    var liveaboardRequest = AddLiveaboardRequest();
    liveaboardRequest.liveaboard = liveaboard;
    try {
      var response = stub.addLiveaboard(
        liveaboardRequest,
      );
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  // get hotel image
  _getliveaboard() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        liveaboardimg = io.File(pickedFile.path);
        lvb = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
          //Text('Hotel Image'),
          Row(
            children: [
              Column(
                children: [Text("Liveaboard image")],
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
                    width: 300,
                  )
                      : Image.file(
                    io.File(liveaboardimg.path),
                    fit: BoxFit.cover,
                    width: 50,
                  )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              // Color(0xfffaea4e3),
                              // Color(0xfffd3ffe8),
                              Color(0xfffcfecd0),
                              Color(0xfffffc5ca),
                            ])),
                    child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {

                  _getliveaboard();
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
            child: AddMoreRoom(this.pinkValue, this.blueValue),
          ),
          SizedBox(height: 30),
          FlatButton(
            onPressed: () => {
              sendLiveaboard(),
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
}
