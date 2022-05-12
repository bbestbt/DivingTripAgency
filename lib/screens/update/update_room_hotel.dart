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
import 'package:diving_trip_agency/screens/update/add_new_amenity.dart';
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

GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;

class AddMoreRoomUpdateHotel extends StatefulWidget {
  List<RoomType> pinkValue = [];
  Hotel eachHotel;
  final customFunction;
  List<List<Amenity>> blueValue;
  AddMoreRoomUpdateHotel(Hotel eachHotel, this.customFunction
      // List<RoomType> pinkValue,
      // List<List<Amenity>> blueValue,
      ) {
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.eachHotel = eachHotel;
  }
  @override
  _AddMoreRoomUpdateHotelState createState() =>
      _AddMoreRoomUpdateHotelState(this.eachHotel);
}

class _AddMoreRoomUpdateHotelState extends State<AddMoreRoomUpdateHotel> {
  int pinkcount = 0;
  List<List<Amenity>> blueValue;
  List<RoomType> pinkValue = [];
  Hotel eachHotel;
  List<RoomType> allRoom = [];

  _AddMoreRoomUpdateHotelState(
    Hotel eachHotel,
    // List<RoomType> pinkValue,
    // List<List<Amenity>> blueValue,
  ) {
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.eachHotel = eachHotel;
  }
  getRoomLength() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = HotelServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listamenityhotelrequest = GetHotelRequest();

    listamenityhotelrequest.id = eachHotel.id;

    hotel = await stub.getHotel(listamenityhotelrequest);

    hotelDetial = hotel;
    return hotelDetial.hotel.roomTypes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        RoomFormHotelUpdate(this.eachHotel, this.allRoom),
        FutureBuilder(
          future: getRoomLength(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                      ),
                  shrinkWrap: true,
                  itemCount: pinkcount,
                  itemBuilder: (BuildContext context, int index) {
                    return RoomForm(
                        pinkcount,
                        this.pinkValue,
                        this.blueValue,
                        index + hotelDetial.hotel.roomTypes.length,
                        eachHotel,
                        widget.customFunction,
                        this.allRoom);
                  });
            } else {
              return Center(child: Text('No room'));
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  pinkcount += 1;
                  // pinkValue.add(new RoomType());
                  // blueValue.add([new Amenity()]);
                });
              },
              color: Color(0xfffff968a),
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
            SizedBox(width: 30),
            MaterialButton(
              onPressed: () {
                setState(() {
                  if (eachHotel.roomTypes.length > 1) {
                    eachHotel.roomTypes.removeLast();
                    print(eachHotel.roomTypes);
                  } else {
                    pinkcount = 0;
                  }
                  // pinkcount -= 1;
                  // pinkValue.remove(new RoomType());
                  // blueValue.remove([new Amenity()]);
                });
              },
              color: Color(0xfffff968a),
              textColor: Colors.white,
              child: Icon(
                Icons.remove,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        FlatButton(onPressed: () {
          print(widget.customFunction(eachHotel.roomTypes));
        }),
      ])),
    );
  }
}

class RoomFormHotelUpdate extends StatefulWidget {
  List<RoomType> allRoom = [];
  Hotel eachHotel;

  var f2 = File();
  RoomFormHotelUpdate(Hotel eachHotel, List<RoomType> allRoom) {
    this.eachHotel = eachHotel;
    this.allRoom = allRoom;
  }
  @override
  _RoomFormHotelUpdateState createState() =>
      _RoomFormHotelUpdateState(this.eachHotel, this.allRoom);
}

class _RoomFormHotelUpdateState extends State<RoomFormHotelUpdate> {
  List<RoomType> allRoom = [];
  Hotel eachHotel;

  _RoomFormHotelUpdateState(this.eachHotel, this.allRoom);
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
    // print('--');
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
                  (index) => InfoCard(index, allRoom, eachHotel),
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
    this.eachHotel = eachHotel;
  }
  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.index, this.allRoom, this.eachHotel);
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
  _InfoCardState(this.index, this.allRoom, this.eachHotel);

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
          Text(index.toString()),
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
            child: AddMoreAmenityUpdateHotel(this.eachHotel, this.index),
            // child: AddMoreAmenityUpdateHotel(this.eachHotel,this.bluecount,this.index, this.blueValue),
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
        print(value);
        allRoom[index].description = value;
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
        print(value);
        allRoom[index].maxGuest = int.parse(value);
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
        print(value);
        allRoom[index].name = value;
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
        print(value);
        allRoom[index].quantity = int.parse(value);
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

class RoomForm extends StatefulWidget {
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  int indexForm;
  Hotel eachHotel;
  final customFunction;
  List<RoomType> allRoom = [];
  var f2 = File();
  RoomForm(
      int pinkcount,
      List<RoomType> pinkValue,
      List<List<Amenity>> blueValue,
      int indexForm,
      Hotel eachHotel,
      this.customFunction,
      List<RoomType> allRoom) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachHotel = eachHotel;
    this.allRoom = allRoom;
  }
  @override
  _RoomFormState createState() => _RoomFormState(
      this.pinkcount,
      this.pinkValue,
      this.blueValue,
      this.indexForm,
      this.eachHotel,
      this.customFunction,
      this.allRoom);
}

class _RoomFormState extends State<RoomForm> {
  int pinkcount;
  String room_description;
  int max_capa;
  double price;
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
  Hotel eachHotel;
  List<RoomType> allRoom = [];
  List<RoomType> newRoom = [];
  XFile rroom;
  final customFunction;
  _RoomFormState(
      int pinkcount,
      List<RoomType> pinkValue,
      List<List<Amenity>> blueValue,
      int indexForm,
      Hotel eachHotel,
      this.customFunction,
      List<RoomType> allRoom) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachHotel = eachHotel;
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
  int count = 0;

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
    print("RoomImages");
    // print(this.pinkValue[this.pinkcount - 1].roomImages);
    print(this.pinkValue[this.pinkcount - 1].roomImages.length);

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
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Text(indexForm.toString()),
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
            child: AddMoreAmenityNew(this.indexForm, this.blueValue),
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
                              width: screenwidth * 0.2,
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
                              width: screenwidth * 0.2,
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
          SizedBox(height: 20),
          FlatButton(
              color: Colors.pink,
              child: Text(
                'Please save before add new divesites',
              ),
              onPressed: () {
                print('ff');
                print(eachHotel.roomTypes);
                var rt = RoomType();
                rt.name = room_name;
                rt.description = room_description;
                rt.quantity = quantity;
                rt.maxGuest = max_capa;
                eachHotel.roomTypes.add(rt);
                // allRoom.add(rt);

                // eachHotel.roomTypes.addAll(allRoom);
                print(eachHotel.roomTypes);

                widget.customFunction(eachHotel.roomTypes);
              }),
          SizedBox(height: 20),
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
        // print('room des start');
        // print(pinkcount);
        // print('room des end');
        room_description = value;
        // newRoom[count].description = value;
      },
      decoration: InputDecoration(
        labelText: "Room description",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // TextFormField buildPriceFormField() {
  //   return TextFormField(
  //     controller: _controllerPrice,
  //     keyboardType: TextInputType.number,
  //     inputFormatters: [
  //       FilteringTextInputFormatter.digitsOnly,
  //     ],
  //     cursorColor: Color(0xFFf5579c6),
  //     // onSaved: (newValue) => price = newValue,
  //     onChanged: (value) {
  //       // print('room price start');
  //       // print(pinkcount);
  //       // print('room price end');
  //       price = double.parse(value);
  //       // pinkValue[pinkcount - 1].price = double.parse(value);
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Price",
  //       filled: true,
  //       fillColor: Color(0xffffee1e8),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  TextFormField buildMaxCapacityFormField() {
    return TextFormField(
      controller: _controllerMax,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      // onSaved: (newValue) => max_capa = newValue,
      onChanged: (value) {
        // print('room max start');
        // print(pinkcount);
        // print('room max end');
        max_capa = int.parse(value);
        // newRoom[count].maxGuest = int.parse(value);
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
      // onSaved: (newValue) => room_name = newValue,
      onChanged: (value) {
        // print('room name start');
        // print(pinkcount);
        // print('room name end');
        // newRoom[count].name = value;
        room_name = value;
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
      // onSaved: (newValue) => quantity = newValue,
      onChanged: (value) {
        // print('room quantity start');
        // print(pinkcount);
        // print('room quantity end');
        // newRoom[count].quantity = int.parse(value);

        // print(value);
        quantity = int.parse(value);
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
