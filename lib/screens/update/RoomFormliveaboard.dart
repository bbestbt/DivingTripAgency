import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addMoreAmenity.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/add_new_amenity_hotel.dart';
import 'package:diving_trip_agency/screens/update/add_new_amenity_liveaboard.dart';

import 'package:diving_trip_agency/screens/update/update_amenity_hotel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'dart:io' as io;

class RoomFormliveaboard extends StatefulWidget {
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  int indexForm;
  final customFunction;
  Liveaboard eachLiveaboard;
  List<RoomType> allRoom = [];
  var f2 = File();
  RoomFormliveaboard(
      int pinkcount,
      List<RoomType> pinkValue,
      List<List<Amenity>> blueValue,
      int indexForm,
      Liveaboard eachLiveaboard,
      this.customFunction,
  List<RoomType> allRoom) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachLiveaboard = eachLiveaboard;
    this.allRoom = allRoom;
  }
  @override
  _RoomFormliveaboardState createState() => _RoomFormliveaboardState(this.pinkcount, this.pinkValue,
      this.blueValue, this.indexForm, this.eachLiveaboard, this.allRoom);
}
class _RoomFormliveaboardState extends State<RoomFormliveaboard> {
  int pinkcount;
  String room_description;
  int max_capa;
  String price;
  // String amenity;
  String selected = null;
  io.File roomimg;
  io.File roomimg2;
  io.File roomimg3;
  String room_type;
  String room_name;
  int quantity;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  int indexForm;
  Liveaboard eachLiveaboard;
  List<RoomType> allRoom = [];
  XFile rroom;
  XFile Xrimg1;
  XFile Xrimg2;
  XFile Xrimg3;

  _RoomFormliveaboardState(
      int pinkcount,
      List<RoomType> pinkValue,
      List<List<Amenity>> blueValue,
      int indexForm,
      Liveaboard eachLiveaboard,
      List<RoomType> allRoom) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachLiveaboard = eachLiveaboard;
    this.allRoom = allRoom;
  }
  final TextEditingController _controllerRoomdescription =
  TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  // final TextEditingController _controllerAmenity = TextEditingController();
  final TextEditingController _controllerRoomtype = TextEditingController();
  final TextEditingController _controllerRoomname = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();

  _getroomimg(int num) async {
    rroom = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (rroom != null) {
      setState(() {
        if (num == 1) {
          roomimg = io.File(rroom.path);
          Xrimg1 = rroom;
        }
        if (num == 2) {
          roomimg2 = io.File(rroom.path);
          Xrimg2 = rroom;
        }
        if (num == 3) {
          roomimg3 = io.File(rroom.path);
          Xrimg3 = rroom;
        }
      });
    }
    if (Xrimg1 != null) {
      var f = File();
      f.filename = Xrimg1.name;
      List<int> a = await Xrimg1.readAsBytes();
      f.file = a;
      if (eachLiveaboard.roomTypes[indexForm].roomImages.length >= 1) {
        eachLiveaboard.roomTypes[indexForm].roomImages.removeAt(0);
      }
      eachLiveaboard.roomTypes[indexForm].roomImages.insert(0, f);
      print("uploaded pic1");
      print(eachLiveaboard.roomTypes[indexForm].roomImages);
    } else if (eachLiveaboard.roomTypes[indexForm].roomImages.length >= 1) {
      var f = File();
      f.filename = eachLiveaboard.roomTypes[indexForm].roomImages[0].filename;
      //this.this.pinkValue[this.pinkcount - 1].roomImages.add(f);
    }



    if (Xrimg2 != null) {
      var f2 = File();
      f2.filename = Xrimg2.name;
      List<int> b = await Xrimg2.readAsBytes();
      f2.file = b;
      if (eachLiveaboard.roomTypes[indexForm].roomImages.length >= 2) {
        eachLiveaboard.roomTypes[indexForm].roomImages.removeAt(1);
      }
      eachLiveaboard.roomTypes[indexForm].roomImages.insert(1, f2);
      print("uploaded pic1");
      print(eachLiveaboard.roomTypes[indexForm].roomImages);
    } else if (eachLiveaboard.roomTypes[indexForm].roomImages.length >= 2) {
      var f2 = File();
      f2.filename = eachLiveaboard.roomTypes[indexForm].roomImages[1].filename;
      //this.this.pinkValue[this.pinkcount - 1].roomImages.add(f);
    }



    if (Xrimg3 != null) {
      var f3 = File();
      f3.filename = Xrimg3.name;
      List<int> c = await Xrimg3.readAsBytes();
      f3.file = c;

      if (eachLiveaboard.roomTypes[indexForm].roomImages.length >= 3) {
        eachLiveaboard.roomTypes[indexForm].roomImages.removeAt(2);
      }
      eachLiveaboard.roomTypes[indexForm].roomImages.insert(2, f3);
      print("uploaded pic1");
      print(eachLiveaboard.roomTypes[indexForm].roomImages);
    } else if (eachLiveaboard.roomTypes[indexForm].roomImages.length >= 3) {
      var f3 = File();
      f3.filename = eachLiveaboard.roomTypes[indexForm].roomImages[2].filename;
      //this.this.pinkValue[this.pinkcount - 1].roomImages.add(f);
    }

  }

  List<Amenity> amValue = [];
  void getAMValue(am) {
    setState(() {
      amValue = am;
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Text(indexForm.toString()),
          SizedBox(height: 20),
          buildRoomNameFormField(),
          SizedBox(height: 20),
          buildRoomDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxCapacityFormField(),
          SizedBox(height: 20),

          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xfffa2b8f2),
                //  Color(0xfffd4f0f0),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreAmenityNewLiveAboard(this.indexForm, this.blueValue,
                this.eachLiveaboard, getAMValue),
          ),
          SizedBox(height: 20),
          buildRoomQuantityFormField(),
          SizedBox(height: 20),

          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: roomimg == null
                      ? Column(
                    children: [
                      Text(''),
                      Text(''),
                    ],
                  )
                      : kIsWeb
                      ? Image.network(
                    roomimg.path,
                    fit: BoxFit.cover,
                    width: screenwidth * 0.1,
                  )
                      : Image.file(
                    io.File(roomimg.path),
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
                            minWidth: 70.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getroomimg(1);
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
                  child: roomimg2 == null
                      ? Column(
                    children: [
                      Text(''),
                      Text(''),
                    ],
                  )
                      : kIsWeb
                      ? Image.network(
                    roomimg2.path,
                    fit: BoxFit.cover,
                    width: screenwidth * 0.1,
                  )
                      : Image.file(
                    io.File(roomimg2.path),
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
                            minWidth: 70.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getroomimg(2);
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
                  child: roomimg3 == null
                      ? Column(
                    children: [
                      Text(''),
                      Text(''),
                    ],
                  )
                      : kIsWeb
                      ? Image.network(
                    roomimg3.path,
                    fit: BoxFit.cover,
                    width: screenwidth * 0.1,
                  )
                      : Image.file(
                    io.File(roomimg3.path),
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
                            minWidth: 70.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getroomimg(3);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          //   FormError(errors: errors),
          // FlatButton(
          //     color: Colors.pink,
          //     child: Text(
          //       'Please save before add new room',
          //     ),
          //     onPressed: () {
          //       print('aa');
          //       print(eachLiveaboard.roomTypes);
          //       // var rt = RoomType();
          //       rt.name = room_name;
          //       rt.description = room_description;
          //       rt.quantity = quantity;
          //       rt.maxGuest = max_capa;
          //       eachLiveaboard.roomTypes[indexForm] = rt;

          //       print(eachLiveaboard.roomTypes);

          //       widget.customFunction(eachLiveaboard.roomTypes);
          //     }),
          // SizedBox(height: 20),
        ]),
      ),
    );
  }
  TextFormField buildRoomDescriptionFormField() {
    return TextFormField(
      controller: _controllerRoomdescription,
      cursorColor: Color(0xFFf5579c6),
      onChanged: (value) {
        room_description = value;
        eachLiveaboard.roomTypes[indexForm].description = value;
      },
      decoration: InputDecoration(
        labelText: "Room description",
        filled: true,
        fillColor: Color(0xfffabddfc),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxCapacityFormField() {
    return TextFormField(
      controller: _controllerMax,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onChanged: (value) {
        // print('room max start');
        // print(pinkcount);
        // print('room max end');
        max_capa = int.parse(value);
        eachLiveaboard.roomTypes[indexForm].maxGuest = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Max capacity",
        filled: true,
        fillColor: Color(0xfffabddfc),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRoomNameFormField() {
    return TextFormField(
      controller: _controllerRoomname,
      cursorColor: Color(0xFFf5579c6),
      onChanged: (value) {
        room_name = value;
        eachLiveaboard.roomTypes[indexForm].name = value;
      },
      decoration: InputDecoration(
        labelText: "Room type",
        filled: true,
        fillColor: Color(0xfffabddfc),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRoomQuantityFormField() {
    return TextFormField(
      controller: _controllerQuantity,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onChanged: (value) {
        quantity = int.parse(value);
        eachLiveaboard.roomTypes[indexForm].quantity = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Room quantity",
        filled: true,
        fillColor: Color(0xfffabddfc),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}