import 'package:country_picker/country_picker.dart';
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
import 'package:diving_trip_agency/screens/update/update_room_hotel.dart';
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

class updateEachHotel extends StatelessWidget {
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  Hotel eachHotel;
  updateEachHotel(Hotel eachHotel) {
    this.eachHotel = eachHotel;
  }
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
    return Scaffold(
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: 600,
          decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Update Hotel",
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
                          child: editHotelForm(this.eachHotel));
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

class editHotelForm extends StatefulWidget {
  Hotel eachHotel;
  editHotelForm(Hotel eachHotel) {
    this.eachHotel = eachHotel;
  }
  @override
  _editHotelFormState createState() => _editHotelFormState(this.eachHotel);
}

class _editHotelFormState extends State<editHotelForm> {
  String hotel_name;
  String highlight;
  String hotel_description;
  String phone;
  io.File hotelimg;
  io.File hotelimg2;
  io.File hotelimg3;
  io.File hotelimg4;
  io.File hotelimg5;
  io.File hotelimg6;
  io.File hotelimg7;
  io.File hotelimg8;
  io.File hotelimg9;
  io.File hotelimg10;

  String address1;
  String address2;
  String postalCode;
  String country;
  String region;
  String city;

  XFile hhotel;
  XFile Xhotel1;
  XFile Xhotel2;
  XFile Xhotel3;
  XFile Xhotel4;
  XFile Xhotel5;
  XFile Xhotel6;
  XFile Xhotel7;
  XFile Xhotel8;
  XFile Xhotel9;
  XFile Xhotel10;
  XFile rroom;
  var hotel = Hotel();
  Hotel eachHotel;
  _editHotelFormState(this.eachHotel);
  List<RoomType> pinkValue = [];
  List<List<Amenity>> blueValue = [[]];
  List<DropdownMenuItem<String>> listStar = [];
  List<String> star = ['1', '2', '3', '4', '5'];
  String starSelected;

  final TextEditingController _controllerHotelname = TextEditingController();
  final TextEditingController _controllerHoteldescription =
      TextEditingController();

  final TextEditingController _controllerPhone = TextEditingController();
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

  void loadData() {
    listStar = [];
    listStar = star
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();
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
  _gethotelimg(int num) async {
    hhotel = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );

    if (hhotel != null) {
      setState(() {
        if (num == 1) {
          hotelimg = io.File(hhotel.path);
          Xhotel1 = hhotel;
        }
        if (num == 2) {
          hotelimg2 = io.File(hhotel.path);
          Xhotel2 = hhotel;
        }
        if (num == 3) {
          hotelimg2 = io.File(hhotel.path);
          Xhotel3 = hhotel;
        }
        if (num == 4) {
          hotelimg4 = io.File(hhotel.path);
          Xhotel4 = hhotel;
        }
        if (num == 5) {
          hotelimg5 = io.File(hhotel.path);
          Xhotel5 = hhotel;
        }
        if (num == 6) {
          hotelimg6 = io.File(hhotel.path);
          Xhotel6 = hhotel;
        }
        if (num == 7) {
          hotelimg7 = io.File(hhotel.path);
          Xhotel7 = hhotel;
        }
        if (num == 8) {
          hotelimg8 = io.File(hhotel.path);
          Xhotel8 = hhotel;
        }
        if (num == 9) {
          hotelimg9 = io.File(hhotel.path);
          Xhotel9 = hhotel;
        }
        if (num == 10) {
          hotelimg10 = io.File(hhotel.path);
          Xhotel10 = hhotel;
        }
      });
    }
  }

  void sendUpdateHotel() async {
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

    eachHotel.name = _controllerHotelname.text;
    eachHotel.description = _controllerHoteldescription.text;

    eachHotel.phone = _controllerPhone.text;

    eachHotel.address.addressLine1 = _controllerAddress.text;
    eachHotel.address.addressLine2 = _controllerAddress2.text;
    eachHotel.address.postcode = _controllerPostalcode.text;
    // eachHotel.address.country = _controllerCountry.text;

    // eachHotel.address.region = _controllerRegion.text;
    eachHotel.address.city = _controllerCity.text;

    if (countrySelected != null) {
      eachHotel.address.country = countrySelected;
    }
    if (regionSelected != null) {
      eachHotel.address.region = regionSelected;
    }
    if (starSelected != null) {
      eachHotel.stars = int.parse(starSelected);
    }

    var address = Address();
    address.addressLine1 = eachHotel.address.addressLine1;
    address.addressLine2 = eachHotel.address.addressLine2;
    address.city = eachHotel.address.city;

    address.postcode = eachHotel.address.postcode;

    if (countrySelected != null) {
      address.country = countrySelected;
    }
    if (regionSelected != null) {
      address.region = regionSelected;
    }

    var hotel = Hotel()..address = address;
    hotel.id = eachHotel.id;
    hotel.name = eachHotel.name;
    hotel.description = eachHotel.description;
    hotel.phone = eachHotel.phone;
    hotel.stars = eachHotel.stars;
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
      hotel.roomTypes.add(room);
    }

    if (Xhotel1 != null) {
      var f = File();
      f.filename = Xhotel1.name;
      List<int> a = await Xhotel1.readAsBytes();
      f.file = a;
      if (eachHotel.images.length >= 1) {
        eachHotel.images.removeAt(0);
      }
      eachHotel.images.insert(0, f);
    } else if (eachHotel.images.length >= 1) {
      var f = File();
      f.filename = eachHotel.images[0].filename;
      //this.eachHotel.images.add(f);
    }

    if (Xhotel2 != null) {
      var f2 = File();
      f2.filename = Xhotel2.name;
      List<int> b = await Xhotel2.readAsBytes();
      f2.file = b;
      if (eachHotel.images.length >= 2) {
        eachHotel.images.removeAt(1);
      }
      eachHotel.images.insert(1, f2);
    } else if (eachHotel.images.length >= 2) {
      var f2 = File();
      f2.filename = eachHotel.images[1].filename;
      //  this.eachHotel.images.add(f2);
    }

    if (Xhotel3 != null) {
      var f3 = File();
      f3.filename = Xhotel3.name;
      List<int> c = await Xhotel3.readAsBytes();
      f3.file = c;
      if (eachHotel.images.length >= 3) {
        eachHotel.images.removeAt(2);
      }
      eachHotel.images.insert(2, f3);
    } else if (eachHotel.images.length >= 3) {
      var f3 = File();
      f3.filename = eachHotel.images[2].filename;
      // this.eachHotel.images.add(f3);
    }

    if (Xhotel4 != null) {
      var f4 = File();
      f4.filename = Xhotel4.name;
      List<int> d = await Xhotel4.readAsBytes();
      f4.file = d;
      if (eachHotel.images.length >= 4) {
        eachHotel.images.removeAt(3);
      }
      eachHotel.images.insert(3, f4);
    } else if (eachHotel.images.length >= 4) {
      var f4 = File();
      f4.filename = eachHotel.images[3].filename;
      // this.eachHotel.images.add(f4);
    }

    if (Xhotel5 != null) {
      var f5 = File();
      f5.filename = Xhotel5.name;
      List<int> e = await Xhotel5.readAsBytes();
      f5.file = e;
      if (eachHotel.images.length >= 5) {
        eachHotel.images.removeAt(4);
      }
      eachHotel.images.insert(4, f5);
    } else if (eachHotel.images.length >= 5) {
      var f5 = File();
      f5.filename = eachHotel.images[4].filename;
      //  this.eachHotel.images.add(f5);
    }

    if (Xhotel6 != null) {
      var f6 = File();
      f6.filename = Xhotel6.name;
      List<int> a = await Xhotel6.readAsBytes();
      f6.file = a;
      if (eachHotel.images.length >= 6) {
        eachHotel.images.removeAt(5);
      }
      eachHotel.images.insert(5, f6);
    } else if (eachHotel.images.length >= 6) {
      var f = File();
      f.filename = eachHotel.images[5].filename;
      //this.eachHotel.images.add(f);
    }

    if (Xhotel7 != null) {
      var f7 = File();
      f7.filename = Xhotel7.name;
      List<int> b = await Xhotel7.readAsBytes();
      f7.file = b;
      if (eachHotel.images.length >= 7) {
        eachHotel.images.removeAt(6);
      }
      eachHotel.images.insert(6, f7);
    } else if (eachHotel.images.length >= 7) {
      var f7 = File();
      f7.filename = eachHotel.images[6].filename;
      //  this.eachHotel.images.add(f7);
    }

    if (Xhotel8 != null) {
      var f8 = File();
      f8.filename = Xhotel8.name;
      List<int> c = await Xhotel8.readAsBytes();
      f8.file = c;
      if (eachHotel.images.length >= 8) {
        eachHotel.images.removeAt(7);
      }
      eachHotel.images.insert(7, f8);
    } else if (eachHotel.images.length >= 8) {
      var f8 = File();
      f8.filename = eachHotel.images[7].filename;
      // this.eachHotel.images.add(f8);
    }

    if (Xhotel9 != null) {
      var f9 = File();
      f9.filename = Xhotel9.name;
      List<int> d = await Xhotel9.readAsBytes();
      f9.file = d;
      if (eachHotel.images.length >= 9) {
        eachHotel.images.removeAt(8);
      }
      eachHotel.images.insert(8, f9);
    } else if (eachHotel.images.length >= 9) {
      var f9 = File();
      f9.filename = eachHotel.images[8].filename;
      // this.eachHotel.images.add(f9);
    }

    if (Xhotel10 != null) {
      var f10 = File();
      f10.filename = Xhotel10.name;
      List<int> e = await Xhotel10.readAsBytes();
      f10.file = e;
      if (eachHotel.images.length >= 10) {
        eachHotel.images.removeAt(9);
      }
      eachHotel.images.insert(9, f10);
    } else if (eachHotel.images.length >= 10) {
      var f10 = File();
      f10.filename = eachHotel.images[9].filename;
      //  this.eachHotel.images.add(f5);
    }

    for (int i = 0; i < eachHotel.images.length; i++) {
      hotel.images.add(eachHotel.images[i]);
    }
    print("hotel.images");
    print(hotel.images);
    final updateRequest = UpdateHotelRequest()..hotel = hotel;
    print(updateRequest);
    try {
      var response = stub.updateHotel(updateRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      _controllerHotelname.text = eachHotel.name;
      _controllerHoteldescription.text = eachHotel.description;
      _controllerPhone.text = eachHotel.phone;
      _controllerAddress.text = eachHotel.address.addressLine1;
      _controllerAddress2.text = eachHotel.address.addressLine2;
      _controllerPostalcode.text = eachHotel.address.postcode;
      _controllerCountry.text = eachHotel.address.country;
      _controllerRegion.text = eachHotel.address.region;
      _controllerCity.text = eachHotel.address.city;
      pinkValue=eachHotel.roomTypes;
    });
  }

  void getRoomValue(r) {
    setState(() {
      pinkValue = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
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
          buildPhoneFormField(),
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
                        : Text(eachHotel.address.country),
                  ),
                )
                    /*child: DropdownButtonFormField(
                    isExpanded: true,
                    value: countrySelected,
                    items: listCountry,
                    hint: Text(eachHotel.address.country),
                    iconSize: 40,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          countrySelected = value;
                          print(value);
                        });
                      }
                    },
                  ),*/
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
                    hint: Text(eachHotel.address.region),
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
          //Text('Hotel Image'),
          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 1
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[0].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel1 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg.path,
                              //eachHotel.images[0].link.toString(),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg.path),
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
                  _gethotelimg(1);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 2
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[1].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel2 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg2.path,
                              //eachHotel.images[1].link.toString(),

                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg2.path),
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
                  _gethotelimg(2);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 3
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[2].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel3 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg3.path,
                              //hotel.images[hotel.images.length-2],
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg3.path),
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
                  _gethotelimg(3);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 4
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[3].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel4 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg4.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg4.path),
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
                  _gethotelimg(4);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 5
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[4].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel5 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg5.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg5.path),
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
                  _gethotelimg(5);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 6
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[5].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel6 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg6.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg6.path),
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
                  _gethotelimg(6);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 7
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[6].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel7 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg7.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg7.path),
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
                  _gethotelimg(7);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 8
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[7].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel8 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg8.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg8.path),
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
                  _gethotelimg(8);
                },
              ),
            ],
          ),

          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 9
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[8].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel9 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg9.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg9.path),
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
                  _gethotelimg(9);
                },
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [Text("image")],
              ),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachHotel.images.length < 10
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(eachHotel.images[9].link.toString())),
              SizedBox(width: 30),
              Center(
                  child: Xhotel10 == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              hotelimg10.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(hotelimg10.path),
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
                  _gethotelimg(10);
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Container(
            color: Colors.white,
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: starSelected,
                items: listStar,
                hint: Text(eachHotel.stars.toString()),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      starSelected = value;
                      print(value);
                    });
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 20),

          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xffffee1e8),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreRoomUpdateHotel(this.eachHotel, getRoomValue),
          ),
          SizedBox(height: 30),

          FlatButton(
            onPressed: () => {
              // print(pinkValue),
              sendUpdateHotel(),
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
      controller: _controllerHotelname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => hotel_name = newValue,
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
      decoration: InputDecoration(
        labelText: "Phone",
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
