import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
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

class RoomFormHotelUpdate extends StatefulWidget {
  List<RoomType> allRoom = [];
  Hotel eachHotel;

  var f2 = File();
  RoomFormHotelUpdate(Hotel eachHotel) {
    this.eachHotel = eachHotel;
  }
  @override
  _RoomFormHotelUpdateState createState() =>
      _RoomFormHotelUpdateState(this.eachHotel);
}

class _RoomFormHotelUpdateState extends State<RoomFormHotelUpdate> {
  List<RoomType> allRoom = [];
  Hotel eachHotel;

  _RoomFormHotelUpdateState(this.eachHotel);
  getRoomType() async {
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
    var listroomrequest = ListRoomTypesRequest();
    listroomrequest.hotelId = eachHotel.id;

    allRoom.clear();
    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        allRoom.add(feature.roomType);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    print('--');
    // print(allRoom);

    return allRoom;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 1110,
      child: FutureBuilder(
        future: getRoomType(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
                spacing: 20,
                runSpacing: 40,
                children: List.generate(
                  allRoom.length,
                  (index) => InfoCard(index, allRoom,eachHotel),
                ));
          } else {
            return Center(child: Text('No room'));
          }
        },
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  int index;
  List<RoomType> allRoom = [];
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
   Hotel eachHotel;

  InfoCard(int index, List<RoomType> allRoom, Hotel eachHotel) {
    this.index = index;
    this.allRoom = allRoom;
    this.eachHotel=eachHotel;

  }
  @override
  State<InfoCard> createState() => _InfoCardState(this.index, this.allRoom,this.eachHotel);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  List<RoomType> allRoom = [];
  String room_description;
  String max_capa;
  String price;
  String selected = null;
  io.File roomimg;
  io.File roomimg2;
  io.File roomimg3;
  String room_type;
  String room_name;
  String quantity;
  XFile rroom;
  Hotel eachHotel;
  int pinkcount;
   int bluecount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  _InfoCardState(this.index, this.allRoom,this.eachHotel);

  final TextEditingController _controllerRoomdescription =
      TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerRoomtype = TextEditingController();
  final TextEditingController _controllerRoomname = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();

  _getroomimg(int num) async {
    rroom = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    var f2 = File();
    f2.filename = rroom.name;
    //f2.filename = 'image.jpg';
    List<int> a = await rroom.readAsBytes();
    f2.file = a;

    this.pinkValue[this.pinkcount - 1].roomImages.add(f2);

    if (rroom != null) {
      setState(() {
        if (num == 1) roomimg = io.File(rroom.path);
        if (num == 2) roomimg2 = io.File(rroom.path);
        if (num == 3) roomimg3 = io.File(rroom.path);
        //roomimg = io.File(rroom.path);
        // rroom = pickedFile;
      });
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

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
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
                color: Color(0xfffd4f0f0),
                borderRadius: BorderRadius.circular(10)),
            child: updateAmenityHotelForm(this.eachHotel,this.bluecount,this.index, this.blueValue),
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
                              width: screenwidth * 0.2,
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
                              width: screenwidth * 0.2,
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
                              width: screenwidth * 0.2,
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
      onSaved: (newValue) => room_description = newValue,
      onChanged: (value) {
        pinkValue[pinkcount - 1].description = value;
      },
      decoration: InputDecoration(
        labelText: "Room description",
        filled: true,
        fillColor: Color(0xffffee1e8),
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
      onSaved: (newValue) => max_capa = newValue,
      onChanged: (value) {
        pinkValue[pinkcount - 1].maxGuest = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Max capacity",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRoomNameFormField() {
    return TextFormField(
      controller: _controllerRoomname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => room_name = newValue,
      onChanged: (value) {
        pinkValue[pinkcount - 1].name = value;
      },
      decoration: InputDecoration(
        labelText: "Room type",
        filled: true,
        fillColor: Color(0xffffee1e8),
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
      onSaved: (newValue) => quantity = newValue,
      onChanged: (value) {
        pinkValue[pinkcount - 1].quantity = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Room quantity",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
