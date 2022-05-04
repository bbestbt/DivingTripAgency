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
    liveaboard.images.add(f);

    if (lvb != null) {
      setState(() {
        if (num == 1) liveaboardimg = io.File(lvb.path);
        if (num == 2) liveaboardimg2 = io.File(lvb.path);
        if (num == 3) liveaboardimg3 = io.File(lvb.path);
        if (num == 4) liveaboardimg4 = io.File(lvb.path);
        if (num == 5) liveaboardimg5 = io.File(lvb.path);
        if (num == 6) liveaboardimg6 = io.File(lvb.path);
        if (num == 7) liveaboardimg7 = io.File(lvb.path);
        if (num == 8) liveaboardimg8 = io.File(lvb.path);
        if (num == 9) liveaboardimg9 = io.File(lvb.path);
        if (num == 10) liveaboardimg10 = io.File(lvb.path);
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
    liveaboard.id=eachLiveaboard.id;
    liveaboard.name = eachLiveaboard.name;
    liveaboard.description = eachLiveaboard.description;
    liveaboard.diverRooms = eachLiveaboard.diverRooms;
    liveaboard.staffRooms = eachLiveaboard.staffRooms;
    liveaboard.totalCapacity = eachLiveaboard.totalCapacity;
    liveaboard.length = eachLiveaboard.length;
    liveaboard.width = eachLiveaboard.width;

    for (int i = 0; i < liveaboard.images.length; i++) {
      eachLiveaboard.images.add(liveaboard.images[i]);
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
                      child: countrySelected != null ? Text(countrySelected) :  Text(eachLiveaboard.address.country),
                    ),
                  )
                ),
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
                              eachLiveaboard.images[eachLiveaboard.images.length-1].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-2].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg2.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-3].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg3.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-4].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg4.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-5].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg5.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-6].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg6.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-7].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg7.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-8].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg8.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-9].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg9.path),
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
                    eachLiveaboard.images[eachLiveaboard.images.length-10].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(liveaboardimg10.path),
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
            child: AddMoreRoomUpdateLiveaboard(this.eachLiveaboard),
          ),
          SizedBox(height: 30),

          FlatButton(
            onPressed: () => {
              sendUpdateLiveaboard(),
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainCompanyScreen(),
                ),
                (route) => false,
              )
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