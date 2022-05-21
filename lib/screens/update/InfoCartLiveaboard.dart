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
import 'package:diving_trip_agency/screens/update/update_amenity_hotel.dart';
import 'package:diving_trip_agency/screens/update/update_amenity_liveaboard.dart';

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

class InfoCard extends StatefulWidget {
  int index;
  List<RoomType> allRoom = [];
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  Liveaboard eachLiveaboard;
  final customFunction;
  InfoCard(int index, List<RoomType> allRoom, Liveaboard eachLiveaboard,
      this.customFunction) {
    this.index = index;
    this.allRoom = allRoom;
    this.eachLiveaboard = eachLiveaboard;
  }
  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.index, this.allRoom, this.eachLiveaboard);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  List<RoomType> allRoom = [];
  String room_description;
  int max_capa;
  String price;
  String selected = null;
  io.File roomimg;
  io.File roomimg2;
  io.File roomimg3;
  String room_type;
  String room_name;
  int quantity;
  XFile rroom;
  XFile xlimg1;
  XFile xlimg2;
  XFile xlimg3;
  Liveaboard eachLiveaboard;
  int pinkcount;
  int bluecount;

  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  _InfoCardState(this.index, this.allRoom, this.eachLiveaboard);

  final TextEditingController _controllerRoomdescription =
  TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerRoomtype = TextEditingController();
  final TextEditingController _controllerRoomname = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();

  get infohroomX3 => null;


  _getroomimg(int num) async {
    rroom  = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // print("pinkvalue");
    // print(eachLiveaboard.roomTypes[index]);

    // this.pinkValue[this.pinkcount - 1].roomImages.add(f2);

    if (rroom  != null) {
      setState(() {
        if (num == 1) {
          roomimg = io.File(rroom.path);
          xlimg1 = rroom;
        }
        if (num == 2) {
          roomimg2 = io.File(rroom.path);
          xlimg2 = rroom;
        }
        if (num == 3) {
          roomimg3 = io.File(rroom.path);
          xlimg3 = rroom;
          print("---xlimg3 triggered---");
        }
        //roomimg = io.File(rroom.path);
        // rroom = pickedFile;
      });
    }

    if (xlimg1 != null) {
      print("xlimg1 not null");
      var f = File();
      f.filename = xlimg1.name;
      List<int> a = await xlimg1.readAsBytes();
      f.file = a;
      if (eachLiveaboard.roomTypes[index].roomImages.length >= 1) {
        eachLiveaboard.roomTypes[index].roomImages.removeAt(0);
      }
      eachLiveaboard.roomTypes[index].roomImages.insert(0, f);
      print("uploaded pic1");
      print(eachLiveaboard.roomTypes[index].roomImages);
    } else if (eachLiveaboard.roomTypes[index].roomImages.length >= 1) {
      var f = File();
      f.filename = eachLiveaboard.roomTypes[index].roomImages[0].filename;
      //this.this.pinkValue[this.pinkcount - 1].roomImages.add(f);
    }

    if (xlimg2 != null) {
      var f2 = File();
      f2.filename = xlimg2.name;
      List<int> b = await xlimg2.readAsBytes();
      f2.file = b;
      if (eachLiveaboard.roomTypes[index].roomImages.length >= 2) {
        eachLiveaboard.roomTypes[index].roomImages.removeAt(1);
      }
      eachLiveaboard.roomTypes[index].roomImages.insert(1, f2);
    } else if (eachLiveaboard.roomTypes[index].roomImages.length >= 2) {
      var f2 = File();
      f2.filename = eachLiveaboard.roomTypes[index].roomImages[1].filename;
      //  this.eachLiveaboard.roomTypes[index].roomImages.add(f2);
    }

    if (xlimg3  != null) {
      var f3 = File();
      f3.filename = xlimg3 .name;
      List<int> c = await xlimg3 .readAsBytes();
      f3.file = c;
      print("Third room before adding");
      print(eachLiveaboard.roomTypes[index].roomImages);
      if (eachLiveaboard.roomTypes[index].roomImages.length >= 3) {
        eachLiveaboard.roomTypes[index].roomImages.removeAt(2);
      }
      eachLiveaboard.roomTypes[index].roomImages.add(f3);
      print("Third room pic");
      print(eachLiveaboard.roomTypes[index].roomImages);
    } else if (eachLiveaboard.roomTypes[index].roomImages.length >= 3) {
      var f3 = File();
      f3.filename = eachLiveaboard.roomTypes[index].roomImages[2].filename;
      // this.eachLiveaboard.roomTypes[index].roomImages.add(f3);
    }

  }
  @override
  void initState() {
    setState(() {
      _controllerRoomdescription.text = allRoom[index].description;
      _controllerMax.text = allRoom[index].maxGuest.toString();
      _controllerRoomname.text = allRoom[index].name;
      _controllerQuantity.text = allRoom[index].quantity.toString();
    });
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
          // Text(index.toString()),
          SizedBox(height: 20),
          buildRoomNameFormField(),
          SizedBox(height: 20),
          buildRoomDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxCapacityFormField(),
          SizedBox(height: 20),
          // buildAmenityFormField(),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xfffa2b8f2),
                // Color(0xfffd4f0f0),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreAmenityUpdateLiveaboard(
                this.eachLiveaboard, this.index, getAMValue),
          ),
          SizedBox(height: 20),
          buildRoomQuantityFormField(),
          SizedBox(height: 20),
          // buildPriceFormField(),
          // SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Container(
                width: MediaQuery.of(context).size.width / 10,
                height: MediaQuery.of(context).size.width / 10,
                //child: divemasterValue.documents[divemasterValue.documents.length-1] == null
                child: eachLiveaboard.roomTypes[index].roomImages.length < 1
                    ? new Container(
                  color: Colors.green,
                )
                    : Image.network(
                  //divemasterValue.documents[divemasterValue.documents.length-1].link.toString())
                    eachLiveaboard.roomTypes[index].roomImages[0].link.toString()
                ),
              ),

              Center(
                  child: xlimg1 == null
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
              Container(
                width: MediaQuery.of(context).size.width / 10,
                height: MediaQuery.of(context).size.width / 10,
                //child: divemasterValue.documents[divemasterValue.documents.length-1] == null
                child: eachLiveaboard.roomTypes[index].roomImages.length < 2
                    ? new Container(
                  color: Colors.green,
                )
                    : Image.network(
                  //divemasterValue.documents[divemasterValue.documents.length-1].link.toString())
                    eachLiveaboard.roomTypes[index].roomImages[1].link.toString()
                ),
              ),
              Center(
                  child: xlimg2 == null
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
              Container(
                width: MediaQuery.of(context).size.width / 10,
                height: MediaQuery.of(context).size.width / 10,
                //child: divemasterValue.documents[divemasterValue.documents.length-1] == null
                child: eachLiveaboard.roomTypes[index].roomImages.length < 3
                    ? new Container(
                  color: Colors.green,
                )
                    : Image.network(
                  //divemasterValue.documents[divemasterValue.documents.length-1].link.toString())
                    eachLiveaboard.roomTypes[index].roomImages[2].link.toString()
                ),
              ),
              Center(
                  child: xlimg3 == null
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

          SizedBox(height: 10),
          Divider(),
        ]),
      ),
    );
  }

  TextFormField buildRoomDescriptionFormField() {
    return TextFormField(
      controller: _controllerRoomdescription,
      cursorColor: Color(0xFFf5579c6),
      // onSaved: (newValue) => room_description = newValue,
      onChanged: (value) {
        eachLiveaboard.roomTypes[index].description = value;
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
        eachLiveaboard.roomTypes[index].maxGuest = int.parse(value);
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
      // onSaved: (newValue) => room_name = newValue,
      onChanged: (value) {
        eachLiveaboard.roomTypes[index].name = value;
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
      // onSaved: (newValue) => quantity = newValue,
      onChanged: (value) {
        eachLiveaboard.roomTypes[index].quantity = int.parse(value);
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