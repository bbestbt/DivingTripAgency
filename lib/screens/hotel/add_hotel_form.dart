import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/hotel/addRoom.dart';
import 'package:diving_trip_agency/screens/hotel/highlight.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class addHotel extends StatefulWidget {
  @override
  _addHotelState createState() => _addHotelState();
}

class _addHotelState extends State<addHotel> {
  String hotel_name;
  String highlight;
  String hotel_description;
  String phone;
  io.File hotelimg;

  PickedFile hhotel;
  PickedFile rroom;

  List<RoomType> pinkValue = [new RoomType()];
  List<List<Amenity>> blueValue = [[new Amenity()]];
  List<DropdownMenuItem<String>> listStar = [];
  List<String> star = ['1', '2', '3', '4', '5'];
  String starSelected = null;

  final List<String> errors = [];
  final TextEditingController _controllerHotelname = TextEditingController();
  final TextEditingController _controllerHoteldescription =
      TextEditingController();

  final TextEditingController _controllerPhone = TextEditingController();

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

  // var authResponse = await AccountClient().login(request)
  void sendHotel() async {
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AgencyServiceClient(
      channel,
      // options: CallOptions(metadata:{'Authorization':  '${bearerToken}'} )
    );
    var hotel = Hotel();
    hotel.hotelName = _controllerHotelname.text;
    hotel.hotelDescription = _controllerHoteldescription.text;
    hotel.phone = _controllerPhone.text;
    hotel.star = int.parse(starSelected);

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await hhotel.readAsBytes();
    f.file = b;
    hotel.images.add(f);

    var f2 = File();
    f2.filename = 'Image.jpg';
    List<int> a = await rroom.readAsBytes();
    f2.file = a;
    //hotel.images.add(f2);

    var room = RoomType();
    var amenity = Amenity();
    for (int i = 0; i < pinkValue.length; i++) {
      // var room=RoomType();
      room.name = pinkValue[i].name;
      room.description = pinkValue[i].description;
      room.maxGuest = pinkValue[i].maxGuest;
      room.price = pinkValue[i].price;
      room.quantity = pinkValue[i].quantity;
      room.roomImages.add(f2);
      hotel.roomTypes.add(room);
      for (int j = 0; j < blueValue.length; j++) {
        amenity.name = blueValue[i][j].name;
        amenity.description = blueValue[i][j].description;
        room.amenities.add(amenity);
      }
    }

    var hotelRequest = AddHotelRequest();
    hotelRequest.hotel = hotel;

    try {
      final box = Hive.box('userInfo');

      var response = await stub.addHotel(hotelRequest);
      String token = box.get('token');
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
 // get hotel image
  _gethotelimg() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        hotelimg = io.File(pickedFile.path);
        hhotel = pickedFile;
      });
    }
  }

  //hotel.images = hotelimg // error, file conflict
    //link api img, room
    //   var authResponse = await client.postAuthenticate(Authenticate()..provider='credentials'
    // ..email=email..password=password);
    //   const bearerToken = authResponse.bearerToken;

    //var hotelRequest = AddHotelRequest();
    //hotelRequest.hotel = hotel;
    //try {
      //var response = stub.addHotel(
       // hotelRequest,
        // options: CallOptions(metadata:{'Authorization':  '${bearerToken}'} )
     // );
    //  print('response: ${response}');
  //  } catch (e) {
  //    print(e);
 //   }
 // }

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
                              io.File(hotelimg.path),
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

            child: AddMoreRoom(this.pinkValue, this.blueValue),

          ),
          SizedBox(height: 30),
          FlatButton(
            onPressed: () => {
              sendHotel(),
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
