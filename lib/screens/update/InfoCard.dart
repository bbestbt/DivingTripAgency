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



class InfoCard extends StatefulWidget { //Infocard for room
  int index;
  List<RoomType> allRoom = [];
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  Hotel eachHotel;
  final customFunction;
  GlobalKey<AnimatedListState> _key;

  InfoCard(
      int index, List<RoomType> allRoom, Hotel eachHotel, this.customFunction, GlobalKey<AnimatedListState> _key) {
    this.index = index;
    this.allRoom = allRoom;
    this.eachHotel = eachHotel;
    this._key = _key;
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
  XFile inforroom;
  XFile infohroomX1;
  XFile infohroomX2;
  XFile infohroomX3;
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
    inforroom  = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // print("pinkvalue");
    // print(eachHotel.roomTypes[index]);

    // this.pinkValue[this.pinkcount - 1].roomImages.add(f2);

    if (inforroom  != null) {
      setState(() {
        if (num == 1) {
          roomimg = io.File(inforroom.path);
          infohroomX1 = inforroom;
        }
        if (num == 2) {
          roomimg2 = io.File(inforroom.path);
          infohroomX2 = inforroom;
        }
        if (num == 3) {
               roomimg3 = io.File(inforroom.path);
          infohroomX3 = inforroom;
        }
        //roomimg = io.File(rroom.path);
        // rroom = pickedFile;
      });
    }

   if (infohroomX1 != null) {
      print("infohroomX1 not null");
      var f = File();
     f.filename = infohroomX1.name;
      List<int> a = await infohroomX1.readAsBytes();
      f.file = a;
      if (eachHotel.roomTypes[index].roomImages.length >= 1) {
        eachHotel.roomTypes[index].roomImages.removeAt(0);
      }
        eachHotel.roomTypes[index].roomImages.insert(0, f);
       print("uploaded pic1");
        print(eachHotel.roomTypes[index].roomImages);
    } else if (eachHotel.roomTypes[index].roomImages.length >= 1) {
        var f = File();
        f.filename = eachHotel.roomTypes[index].roomImages[0].filename;
        //this.this.pinkValue[this.pinkcount - 1].roomImages.add(f);
      }

    if (infohroomX2 != null) {
        var f2 = File();
       f2.filename = infohroomX2.name;
        List<int> b = await infohroomX2.readAsBytes();
        f2.file = b;
        if (eachHotel.roomTypes[index].roomImages.length >= 2) {
          eachHotel.roomTypes[index].roomImages.removeAt(1);
      eachHotel.roomTypes[index].roomImages.insert(1, f2);
      } else if (eachHotel.roomTypes[index].roomImages.length >= 2) {
        var f2 = File();
      f2.filename = eachHotel.roomTypes[index].roomImages[1].filename;
        //  this.eachHotel.roomTypes[index].roomImages.add(f2);
      }

      if (infohroomX3  != null) {
        var f3 = File();
        f3.filename = infohroomX3 .name;
        List<int> c = await infohroomX3 .readAsBytes();
        f3.file = c;
         if (eachHotel.roomTypes[index].roomImages.length >= 3) {
          eachHotel.roomTypes[index].roomImages.removeAt(2);
        }
        eachHotel.roomTypes[index].roomImages.insert(2, f3);
      } else if (eachHotel.roomTypes[index].roomImages.length >= 3) {
        var f3 = File();
         f3.filename = eachHotel.roomTypes[index].roomImages[2].filename;
        // this.eachHotel.roomTypes[index].roomImages.add(f3);
      }

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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        print("key info "+widget._key.toString());
          print('delete at :' + index.toString());
        print('before delete');
        print(eachHotel.roomTypes);
        eachHotel.roomTypes.removeAt(index);
        // AnimatedListRemovedItemBuilder builder = (context, animation) {
        //   return InfoCard(
        //       index, eachHotel.roomTypes, eachHotel, widget.customFunction);
        // };

        // _key.currentState.removeItem(index, builder);
       
        print('after delete');
        print(eachHotel.roomTypes);
        widget._key.currentState.removeItem(
            this.index,
            (context, animation) => InfoCard(
                index, eachHotel.roomTypes, eachHotel, widget.customFunction,widget._key));
        print('after send value');
        print(eachHotel.roomTypes);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: Text(
          "Would you like to delete " + eachHotel.roomTypes[index].name + "?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Text(index.toString()),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => {
                      showAlertDialog(context),
                      // print(eachHotel.roomTypes[index]),
                      // setState(() {
                      // print('r');
                      // print(eachHotel.roomTypes.length);

                      // print('m');
                      // print(eachHotel.roomTypes.length);
                      // })
                    }),
          ),
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
              // color: Color(0xfffd4f0f0),
                color: Color(0xfffa2b8f2),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreAmenityUpdateHotel(
                this.eachHotel, this.index, getAMValue),
            // child: AddMoreAmenityUpdateHotel(this.eachHotel,this.bluecount,this.index, this.blueValue),
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
                  child: infohroomX1 == null
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
                    io.File(
                      roomimg.path,
                    ),
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
                  child: infohroomX2 == null
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
              Center(
                  child: infohroomX3 == null
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
      onSaved: (newValue) => room_description = newValue,
      onChanged: (value) {
        print(value);
        eachHotel.roomTypes[index].description = value;
        print(eachHotel.roomTypes[index]);
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
      onSaved: (newValue) => max_capa = newValue,
      onChanged: (value) {
        print(value);
        eachHotel.roomTypes[index].maxGuest = int.parse(value);
        print(eachHotel.roomTypes[index]);
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
      onSaved: (newValue) => room_name = newValue,
      onChanged: (value) {
        print(value);
        eachHotel.roomTypes[index].name = value;
        print(eachHotel.roomTypes[index]);
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
      onSaved: (newValue) => quantity = newValue,
      onChanged: (value) {
        print(value);
        eachHotel.roomTypes[index].quantity = int.parse(value);
        print(eachHotel.roomTypes[index]);
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