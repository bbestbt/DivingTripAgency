import 'package:country_picker/country_picker.dart';
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addRoom.dart';

import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:diving_trip_agency/screens/update/update_room_liveaboard.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class updateEachLiveaboard extends StatelessWidget {
  Liveaboard eachLiveaboard;
  updateEachLiveaboard(Liveaboard eachLiveaboard) {
    this.eachLiveaboard = eachLiveaboard;
  }
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  getProfile() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final pf = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    profile = await pf.getProfile(new Empty());
    if (profile.hasAgency()) {
      user_profile = profile;
      return user_profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(eachLiveaboard.id);
    return Scaffold(
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Update Liveaboard",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 1110,
                child: FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: editLiveaboardForm(this.eachLiveaboard));
                    } else {
                      return Center(child: Text('User is not logged in'));
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class editLiveaboardForm extends StatefulWidget {
  Liveaboard eachLiveaboard;
  editLiveaboardForm(Liveaboard eachLiveaboard) {
    this.eachLiveaboard = eachLiveaboard;
    // print('id'+eachLiveaboard.id.toString());
  }
  @override
  _editLiveaboardFormState createState() =>
      _editLiveaboardFormState(this.eachLiveaboard);
}

class _editLiveaboardFormState extends State<editLiveaboardForm> {
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

  XFile liveX1;
  XFile liveX2;
  XFile liveX3;
  XFile liveX4;
  XFile liveX5;
  XFile liveX6;
  XFile liveX7;
  XFile liveX8;
  XFile liveX9;
  XFile liveX10;
  var liveaboard = Liveaboard();
  XFile lvb;
  XFile rroom;
  Liveaboard eachLiveaboard;
  // List<RoomType> pinkValue = [new RoomType()];
  // List<List<Amenity>> blueValue = [
  //   [new Amenity()]
  // ];
  _editLiveaboardFormState(this.eachLiveaboard);

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
    //eachLiveaboard.images.removeAt(num-1);
    eachLiveaboard.images.add(f);

    if (lvb != null) {
      setState(() {
        if (num == 1) {
          liveaboardimg = io.File(lvb.path);
          liveX1 = lvb;
        }
        if (num == 2) {
          liveaboardimg2 = io.File(lvb.path);
          liveX2 = lvb;
        }
        if (num == 3) {
          liveaboardimg3 = io.File(lvb.path);
          liveX3 = lvb;
        }
        if (num == 4) {
          liveaboardimg4 = io.File(lvb.path);
          liveX4 = lvb;
        }
        if (num == 5) {
          liveaboardimg5 = io.File(lvb.path);
          liveX5 = lvb;
        }
        if (num == 6) {
          liveaboardimg6 = io.File(lvb.path);
          liveX6 = lvb;
        }
        if (num == 7) {
          liveaboardimg7 = io.File(lvb.path);
          liveX7 = lvb;
        }
        if (num == 8) {
          liveaboardimg8 = io.File(lvb.path);
          liveX8 = lvb;
        }
        if (num == 9) {
          liveaboardimg9 = io.File(lvb.path);
          liveX9 = lvb;
        }
        if (num == 10) {
          liveaboardimg10 = io.File(lvb.path);
          liveX10 = lvb;
        }
        //liveaboardimg = io.File(lvb.path);
      });
    }
  }

  void sendUpdateLiveaboard() async {
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

    eachLiveaboard.name = _controllerLiveaboardname.text;
    eachLiveaboard.description = _controllerLiveaboarddescription.text;

    eachLiveaboard.width = double.parse(_controllerWidth.text);

    eachLiveaboard.length = double.parse(_controllerLength.text);
    eachLiveaboard.staffRooms = int.parse(_controllerStaffroom.text);
    eachLiveaboard.diverRooms = int.parse(_controllerDiverroom.text);
    eachLiveaboard.totalCapacity = int.parse(_controllerTotalcapacity.text);

    eachLiveaboard.address.addressLine1 = _controllerAddress.text;
    eachLiveaboard.address.addressLine2 = _controllerAddress2.text;
    eachLiveaboard.address.postcode = _controllerPostalcode.text;

    eachLiveaboard.address.city = _controllerCity.text;

    if (countrySelected != null) {
      eachLiveaboard.address.country = countrySelected;
    }
    if (regionSelected != null) {
      eachLiveaboard.address.region = regionSelected;
    }

    var address = Address();
    address.addressLine1 = eachLiveaboard.address.addressLine1;
    address.addressLine2 = eachLiveaboard.address.addressLine2;
    address.city = eachLiveaboard.address.city;

    address.postcode = eachLiveaboard.address.postcode;

    if (countrySelected != null) {
      address.country = countrySelected;
    }
    if (regionSelected != null) {
      address.region = regionSelected;
    }

    var liveaboard = Liveaboard()..address = address;
    liveaboard.id = eachLiveaboard.id;
    liveaboard.name = eachLiveaboard.name;
    liveaboard.description = eachLiveaboard.description;
    liveaboard.diverRooms = eachLiveaboard.diverRooms;
    liveaboard.staffRooms = eachLiveaboard.staffRooms;
    liveaboard.totalCapacity = eachLiveaboard.totalCapacity;
    liveaboard.length = eachLiveaboard.length;
    liveaboard.width = eachLiveaboard.width;

    print(pinkValue);
    print(pinkValue.length);
    for (int i = 0; i < pinkValue.length; i++) {
      var room = RoomType();
      for (int j = 0; j < pinkValue[i].amenities.length; j++) {
        var amenity = Amenity();
        amenity.id = pinkValue[i].amenities[j].id;
        amenity.name = pinkValue[i].amenities[j].name;

        room.amenities.add(amenity);
      }
      room.name = pinkValue[i].name;
      room.description = pinkValue[i].description;
      room.maxGuest = pinkValue[i].maxGuest;
      // room.price = pinkValue[i].price;
      room.quantity = pinkValue[i].quantity;

      // for (int j = 0; j < pinkValue[i].roomImages.length; j++) {
      //   room.roomImages.add(pinkValue[i].roomImages[j]);
      //   print("room.roomImages");
      //   print("-------------");
      //   print(room.roomImages);
      // print(pinkValue[i].roomImages.length);
      // }
      liveaboard.roomTypes.add(room);
    }

    if (liveX1 != null) {
      var f = File();
      f.filename = liveX1.name;
      List<int> a = await liveX1.readAsBytes();
      f.file = a;
      if (eachLiveaboard.images.length >= 1) {
        eachLiveaboard.images.removeAt(0);
      }
      eachLiveaboard.images.insert(0, f);
    } else if (eachLiveaboard.images.length >= 1) {
      var f = File();
      f.filename = eachLiveaboard.images[0].filename;
      //this.eachLiveaboard.images.add(f);
    }

    if (liveX2 != null) {
      var f2 = File();
      f2.filename = liveX2.name;
      List<int> b = await liveX2.readAsBytes();
      f2.file = b;
      if (eachLiveaboard.images.length >= 2) eachLiveaboard.images.removeAt(1);
      eachLiveaboard.images.insert(1, f2);
    } else if (eachLiveaboard.images.length >= 2) {
      var f2 = File();
      f2.filename = eachLiveaboard.images[1].filename;
      //  this.eachLiveaboard.images.add(f2);
    }

    if (liveX3 != null) {
      var f3 = File();
      f3.filename = liveX3.name;
      List<int> c = await liveX3.readAsBytes();
      f3.file = c;
      if (eachLiveaboard.images.length >= 3) eachLiveaboard.images.removeAt(2);
      eachLiveaboard.images.insert(2, f3);
    } else if (eachLiveaboard.images.length >= 3) {
      var f3 = File();
      f3.filename = eachLiveaboard.images[2].filename;
      // this.eachLiveaboard.images.add(f3);
    }

    if (liveX4 != null) {
      var f4 = File();
      f4.filename = liveX4.name;
      List<int> d = await liveX4.readAsBytes();
      f4.file = d;
      if (eachLiveaboard.images.length >= 4) eachLiveaboard.images.removeAt(3);
      eachLiveaboard.images.insert(3, f4);
    } else if (eachLiveaboard.images.length >= 4) {
      var f4 = File();
      f4.filename = eachLiveaboard.images[3].filename;
      // this.eachLiveaboard.images.add(f4);
    }

    if (liveX5 != null) {
      var f5 = File();
      f5.filename = liveX5.name;
      List<int> e = await liveX5.readAsBytes();
      f5.file = e;
      if (eachLiveaboard.images.length >= 5) eachLiveaboard.images.removeAt(4);
      eachLiveaboard.images.insert(4, f5);
    } else if (eachLiveaboard.images.length >= 5) {
      var f5 = File();
      f5.filename = eachLiveaboard.images[4].filename;
      //  this.eachLiveaboard.images.add(f5);
    }

    if (liveX6 != null) {
      var f6 = File();
      f6.filename = liveX6.name;
      List<int> a = await liveX6.readAsBytes();
      f6.file = a;
      if (eachLiveaboard.images.length >= 6) eachLiveaboard.images.removeAt(5);
      eachLiveaboard.images.insert(5, f6);
    } else if (eachLiveaboard.images.length >= 6) {
      var f = File();
      f.filename = eachLiveaboard.images[5].filename;
      //this.eachLiveaboard.images.add(f);
    }

    if (liveX7 != null) {
      var f7 = File();
      f7.filename = liveX7.name;
      List<int> b = await liveX7.readAsBytes();
      f7.file = b;
      if (eachLiveaboard.images.length >= 7) eachLiveaboard.images.removeAt(6);
      eachLiveaboard.images.insert(6, f7);
    } else if (eachLiveaboard.images.length >= 7) {
      var f7 = File();
      f7.filename = eachLiveaboard.images[6].filename;
      //  this.eachLiveaboard.images.add(f7);
    }

    if (liveX8 != null) {
      var f8 = File();
      f8.filename = liveX8.name;
      List<int> c = await liveX8.readAsBytes();
      f8.file = c;
      if (eachLiveaboard.images.length >= 8) eachLiveaboard.images.removeAt(7);
      eachLiveaboard.images.insert(7, f8);
    } else if (eachLiveaboard.images.length >= 8) {
      var f8 = File();
      f8.filename = eachLiveaboard.images[7].filename;
      // this.eachLiveaboard.images.add(f8);
    }

    if (liveX9 != null) {
      var f9 = File();
      f9.filename = liveX9.name;
      List<int> d = await liveX9.readAsBytes();
      f9.file = d;
      if (eachLiveaboard.images.length >= 9) eachLiveaboard.images.removeAt(8);
      eachLiveaboard.images.insert(8, f9);
    } else if (eachLiveaboard.images.length >= 9) {
      var f9 = File();
      f9.filename = eachLiveaboard.images[8].filename;
      // this.eachLiveaboard.images.add(f9);
    }

    if (liveX10 != null) {
      var f10 = File();
      f10.filename = liveX10.name;
      List<int> e = await liveX10.readAsBytes();
      f10.file = e;
      if (eachLiveaboard.images.length >= 10) {
        eachLiveaboard.images.removeAt(9);
      }
      eachLiveaboard.images.insert(9, f10);
    } else if (eachLiveaboard.images.length >= 10) {
      var f10 = File();
      f10.filename = eachLiveaboard.images[9].filename;
      //  this.eachLiveaboard.images.add(f5);
    }
    print("eachliveaboard images: ");
    print(eachLiveaboard.images);
    for (int i = 0; i < eachLiveaboard.images.length; i++) {
      liveaboard.images.add(eachLiveaboard.images[i]);
    }

    final updateRequest = UpdateLiveaboardRequest()..liveaboard = liveaboard;
    print(updateRequest);
    try {
      var response = stub.updateLiveaboard(updateRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      _controllerLiveaboardname.text = eachLiveaboard.name;
      _controllerLiveaboarddescription.text = eachLiveaboard.description;
      _controllerAddress.text = eachLiveaboard.address.addressLine1;
      _controllerAddress2.text = eachLiveaboard.address.addressLine2;
      _controllerPostalcode.text = eachLiveaboard.address.postcode;
      _controllerCountry.text = eachLiveaboard.address.country;
      _controllerRegion.text = eachLiveaboard.address.region;
      _controllerCity.text = eachLiveaboard.address.city;
      _controllerWidth.text = eachLiveaboard.width.toString();
      _controllerLength.text = eachLiveaboard.length.toString();
      _controllerStaffroom.text = eachLiveaboard.staffRooms.toString();
      _controllerDiverroom.text = eachLiveaboard.diverRooms.toString();
      _controllerTotalcapacity.text = eachLiveaboard.totalCapacity.toString();
      pinkValue = eachLiveaboard.roomTypes;
    });
    print("What eachLiveaboard has:");
    print(eachLiveaboard);
  }

  List<RoomType> pinkValue = [];
  List<List<Amenity>> blueValue = [[]];
  void getRoomValue(r) {
    setState(() {
      pinkValue = r;
    });
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
                    child: InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          countrySelected = country.name;
                        });
                        //print("_country");
                        //print(_country.name);
                      },
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Select country",
                    ),
                    child: countrySelected != null
                        ? Text(countrySelected)
                        : Text(eachLiveaboard.address.country),
                  ),
                )),
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
                    hint: Text(eachLiveaboard.address.region),
                    iconSize: 40,
                    onChanged: (value) {
                      if (value != null) {
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
                  child: eachLiveaboard.images.length < 1
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              //liveaboardimg.path,
                              eachLiveaboard.images[0].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              SizedBox(width: 30),
              Center(
                child: liveX1 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 2
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              //liveaboardimg2.path,
                              eachLiveaboard.images[1].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg2.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX2 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 3
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[2].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg3.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX3 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 4
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[3].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg4.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX4 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 5
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[4].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg5.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX5 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 6
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[5].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg6.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX6 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 7
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[6].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg7.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX7 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 8
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[7].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg8.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX8 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 9
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[8].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg9.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX9 == null
                    ? Text('')
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
                          ),
              ),
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
                  child: eachLiveaboard.images.length < 10
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              eachLiveaboard.images[9].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg10.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              Center(
                child: liveX10 == null
                    ? Text('')
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
                          ),
              ),
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
            child:
                AddMoreRoomUpdateLiveaboard(this.eachLiveaboard, getRoomValue),
          ),
          SizedBox(height: 30),

          FlatButton(
            onPressed: () => {
              print(pinkValue),
              // sendUpdateLiveaboard(),
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => MainCompanyScreen(),
              //   ),
              //   (route) => false,
              // )
            },
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
      controller: _controllerLiveaboardname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => liveaboard_name = newValue,
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
