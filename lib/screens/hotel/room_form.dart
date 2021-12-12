import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class RoomForm extends StatefulWidget {
  String count;
  RoomForm(String count) {
    this.count = count;
  }
  @override
  _RoomFormState createState() => _RoomFormState(this.count);
}

class _RoomFormState extends State<RoomForm> {
  String count;
  String room_description;
  String max_capa;
  String price;
  String amenity;
  String selected = null;
  File roomimg;
  String room_type;
  _RoomFormState(String count) {
    this.count = count;
  }
  final List<String> errors = [];
  final TextEditingController _controllerRoomdescription =
      TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerAmenity = TextEditingController();
  final TextEditingController _controllerRoomyype = TextEditingController();

  List<DropdownMenuItem<String>> listRoom = [];
  List<Room_RoomType> roomtype = [
    Room_RoomType.SINGLE,
    Room_RoomType.DOUBLE,
    Room_RoomType.TRIPLE,
    Room_RoomType.QUAD,
    Room_RoomType.QUEEN,
    Room_RoomType.KING,
    Room_RoomType.TWIN,
    Room_RoomType.HOLLYWOOD_TWIN_ROOM,
    Room_RoomType.DOUBLE_DOUBLE,
    Room_RoomType.STUDIO,
    Room_RoomType.EXECUTEIVE_SUITE,
    Room_RoomType.MINI_SUITE,
    Room_RoomType.PRESIDENTAL_SUITE,
    Room_RoomType.APARTMENT,
    Room_RoomType.CONNECTING_ROOMS,
    Room_RoomType.MURPHY_ROOM,
    Room_RoomType.DISABLED_ROOM,
    Room_RoomType.CABANA,
    Room_RoomType.ADJOINING_ROOMS,
    Room_RoomType.ADJACENT_ROOMS,
    Room_RoomType.VILLA,
    Room_RoomType.FLOORED_ROOM,
    Room_RoomType.SMOKING_NON_SMOKING,
  ];

  void loadData() {
    // roomtype.forEach((element) {
    //   print(element);
    // });
    listRoom = [];
    listRoom = roomtype
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
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

  _getroomimg() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        roomimg = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //loadData();
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          // Container(
          //   color: Color(0xffffee1e8),
          //   child: Center(
          //     child: DropdownButton(
          //       isExpanded: true,
          //       value: selected,
          //       items: listRoom,
          //       hint: Text('  Select room type'),
          //       iconSize: 40,
          //       onChanged: (value) {
          //         setState(() {
          //           selected = value;
          //           print(value);
          //         });
          //       },
          //     ),
          //   ),
          // ),
          buildRoomTypeFormField(),
          SizedBox(height: 20),
          buildRoomDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxCapacityFormField(),
          SizedBox(height: 20),
          buildAmenityFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [Text("Room image")],
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
                    width: 300,
                  )
                      : Image.file(
                    File(roomimg.path),
                    fit: BoxFit.cover,
                    width: 50,
                  )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(decoration: BoxDecoration(
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
                        constraints: const BoxConstraints(minWidth:88.0,minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getroomimg();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          buildPriceFormField(),
          //   FormError(errors: errors),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildRoomDescriptionFormField() {
    return TextFormField(
      controller: _controllerRoomdescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => room_description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter room description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter room description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Room description",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: _controllerPrice,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => price = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter price");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter price");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxCapacityFormField() {
    return TextFormField(
      controller: _controllerMax,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => max_capa = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter max capacity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter max capacity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Max capacity",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAmenityFormField() {
    return TextFormField(
      controller: _controllerAmenity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => amenity = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter amenity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter amenity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Amenity",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  
  TextFormField buildRoomTypeFormField() {
    return TextFormField(
      controller: _controllerRoomyype,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => room_type = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter room type");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter room type");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Room type",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
