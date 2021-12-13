import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/hotel/addRoom.dart';
import 'package:diving_trip_agency/screens/hotel/highlight.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class addHotel extends StatefulWidget {
  @override
  _addHotelState createState() => _addHotelState();
}

class _addHotelState extends State<addHotel> {
  String hotel_name;
  String highlight;
  String hotel_description;
  String phone;
  File hotelimg;

  List<DropdownMenuItem<String>> listStar = [];
  List<String> star = ['1', '2', '3', '4', '5'];
  String starSelected = null;

  final List<String> errors = [];
  final TextEditingController _controllerHotelname = TextEditingController();
  final TextEditingController _controllerHoteldescription =
      TextEditingController();

  final TextEditingController _controllerPhone = TextEditingController();

  _gethotelimg() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        hotelimg = File(pickedFile.path);
      });
    }
  }

  void loadData() {
    listStar = [];
    listStar = star
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

  void sendHotel() {
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AgencyServiceClient(channel);
    var hotel = Hotel();
    hotel.hotelName = _controllerHotelname.text;
    hotel.hotelDescription = _controllerHoteldescription.text;
    hotel.phone = _controllerPhone.text;
    hotel.star = int.parse(starSelected);
    //hotel.images = hotelimg // error, file conflict
    //link api img, room

    var hotelRequest = AddHotelRequest();
    hotelRequest.hotel = hotel;

    try {
      var response = stub.addHotel(hotelRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
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
          buildHotelNameFormField(),
          SizedBox(height: 20),
          buildHotelDescriptionFormField(),
          SizedBox(height: 20),
          buildPhoneFormField(),
          SizedBox(height: 20),
          //Text('Hotel Image'),
          Row(
            children: [
              Column(
                children: [Text("Hotel image")],
              ),
              Center(
                  child: hotelimg == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg.path,
                              fit: BoxFit.cover,
                              width: 300,
                            )
                          : Image.file(
                              File(hotelimg.path),
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
                  _gethotelimg();
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Container(
            color: Colors.white,
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: starSelected,
                items: listStar,
                hint: Text('  Select star'),
                iconSize: 40,
                onChanged: (value) {
                  starSelected = value;
                  setState(() {
                    starSelected = value;
                    print(value);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),

          // Container(
          //         width: MediaQuery.of(context).size.width / 1.5,
          //          decoration: BoxDecoration(
          //               color: Color(0xfffd4f0f0),
          //               borderRadius: BorderRadius.circular(10)),
          //         child: AddMoreHighlight(),

          //       ), SizedBox(height: 30),

          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xffffee1e8),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreRoom(),
          ),
          SizedBox(height: 30),
          FlatButton(
            onPressed: () => {},
            color: Color(0xfff75BDFF),
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildHotelNameFormField() {
    return TextFormField(
      controller: _controllerHotelname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => hotel_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter hotel name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter hotel name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Hotel name",
        filled: true,
        //fillColor: Color(0xFFFd0efff),
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildHotelDescriptionFormField() {
    return TextFormField(
      controller: _controllerHoteldescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => hotel_description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter hotel description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter hotel description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Hotel description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter phone");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter phone");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
