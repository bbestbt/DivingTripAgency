import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:fixnum/fixnum.dart';
import 'package:country_picker/country_picker.dart';

import '../sectionTitile.dart';

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;
GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;

class updateEachTripTemplate extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  TripWithTemplate eachTrip;
  updateEachTripTemplate(TripWithTemplate eachTrip) {
    this.eachTrip = eachTrip;
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
    // return profile;

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
          decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Update Triptemplate",
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
                          child: updateTriptemplateForm(this.eachTrip));
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

class updateTriptemplateForm extends StatefulWidget {
  TripWithTemplate eachTrip;
  updateTriptemplateForm(TripWithTemplate eachTrip) {
    this.eachTrip = eachTrip;
  }
  @override
  _updateTriptemplateFormState createState() =>
      _updateTriptemplateFormState(this.eachTrip);
}

class _updateTriptemplateFormState extends State<updateTriptemplateForm> {
  TripWithTemplate eachTrip;
  final TextEditingController _controllerTripname = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerAddress2 = TextEditingController();
  final TextEditingController _controllerPostalcode = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  // final TextEditingController _controllerPrice = TextEditingController();
  List<TextEditingController> _controllerPrice = new List();
  List<RoomType> allRoom = [];
  String triptype = '';
  String boatname;
  TripTemplate triptemplate;
  _updateTriptemplateFormState(TripWithTemplate eachTrip) {
    this.eachTrip = eachTrip;
  }

  String tripname;
  String description;
  io.File Pictrip;
  io.File Pictrip2;
  io.File Pictrip3;
  io.File Pictrip4;
  io.File Pictrip5;
  io.File Pictrip6;
  io.File Pictrip7;
  io.File Pictrip8;
  io.File Boatpic;
  io.File Schedule;
  String price;
  List<RoomTypeTripPrice> roomPrice = [];
  XFile pt;
  XFile bt;
  XFile sc;
  String selected = null;

  Map<String, int> tripTypeMap = {};
  Map<String, dynamic> hotelTypeMap = {};
  Map<String, dynamic> liveaboardTypeMap = {};
  List<DropdownMenuItem<String>> listBoat = [];
  List<String> boat = [];
  String boatSelected;
  Map<String, dynamic> boatMap = {};

  List<DropdownMenuItem<String>> listTrip = [];
  List<TripType> trip = [TripType.ONSHORE, TripType.OFFSHORE];

  List<String> hotel = [];
  List<String> liveaboard = [];
  List<String> triptypee = [];
  String selectedTriptype;
  String selectedsleep;

  String address1;
  String address2;
  String postalCode;
  String country;
  String region;
  String city;

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
  List<DropdownMenuItem<String>> listTriptemplate = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _controllerTripname.text = eachTrip.tripTemplate.name;
    _controllerDescription.text = eachTrip.tripTemplate.description;
    _controllerAddress.text = eachTrip.tripTemplate.address.addressLine1;
    _controllerAddress2.text = eachTrip.tripTemplate.address.addressLine2;
    _controllerPostalcode.text = eachTrip.tripTemplate.address.postcode;
    _controllerCity.text = eachTrip.tripTemplate.address.city;
  }

  void loadData() async {
    listCountry = [];
    listCountry = countryName
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();

    listRegion = [];
    listRegion = regionName
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();

    trip.forEach((element) {
      // print(element);
    });
    await getData();
    setState(() {
      listBoat = [];
      listBoat = boat
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();

      listTrip = [];
      listTrip = trip
          .map((val) => DropdownMenuItem<String>(
              child: Text(val.toString()), value: val.value.toString()))
          .toList();

      listTriptemplate = [];
      listTriptemplate = triptemplateData
          .map((val) => DropdownMenuItem<String>(
              child: Text(val.toString()), value: val.toString()))
          .toList();
      String value;

      for (var i = 0; i < TripType.values.length; i++) {
        value = TripType.valueOf(i).toString();
        tripTypeMap[value] = i;
      }
    });

    // print(tripTypeMap);
  }

  int count = 0;

  /// Get from gallery
  _getPictrip(int num) async {
    pt = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f = File();
    f.filename = pt.name;
    //f2.filename = 'image.jpg';
    List<int> a = await pt.readAsBytes();
    f.file = a;
    //this.imagelist.add(f);
    this.triptemplate.images.add(f);
    print("TripImages");
    print(this.triptemplate.images);

    if (pt != null) {
      setState(() {
        // imagelist.add(io.File(pt.path));
        if (num == 1) Pictrip = io.File(pt.path);
        if (num == 2) Pictrip2 = io.File(pt.path);
        if (num == 3) Pictrip3 = io.File(pt.path);
        if (num == 4) Pictrip4 = io.File(pt.path);
        if (num == 5) Pictrip5 = io.File(pt.path);
        if (num == 6) Pictrip6 = io.File(pt.path);
        if (num == 7) Pictrip7 = io.File(pt.path);
        if (num == 8) Pictrip8 = io.File(pt.path);
      });
    }
  }

  _getBoatpic() async {
    bt = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f2 = File();
    f2.filename = bt.name;
    //f2.filename = 'image.jpg';
    List<int> b = await bt.readAsBytes();
    f2.file = b;

    this.triptemplate.images.add(f2);

    if (bt != null) {
      setState(() {
        Boatpic = io.File(bt.path);
      });
    }
  }

  _getSchedule() async {
    sc = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f3 = File();
    f3.filename = sc.name;
    //f2.filename = 'image.jpg';
    List<int> c = await sc.readAsBytes();
    f3.file = c;

    this.triptemplate.images.add(f3);
    if (sc != null) {
      setState(() {
        Schedule = io.File(sc.path);
      });
    }
  }

  List<String> triptemplateData = [];
  String triptemplateSelected;
  Map<String, TripTemplate> triptemplateTypeMap = {};
  getData() async {
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
    var hotelrequest = ListHotelsRequest();
    var liveaboardrequest = ListLiveaboardsRequest();
    var boatrequest = ListBoatsRequest();
    var triptemplaterequest = ListTripTemplatesRequest();

    try {
      // var response = await stub.listBoats(boatrequest);
      // print(token);
      // print(response);

      await for (var feature in stub.listBoats(boatrequest)) {
        //   print(feature.boat.name);
        boat.add(feature.boat.name);
        boatMap[feature.boat.name] = feature.boat.id;
      }
      // print(boat);
      // print(boat.runtimeType);

      await for (var feature in stub.listHotels(hotelrequest)) {
        //  print(feature.hotel.name);
        hotel.add(feature.hotel.name);
        hotelTypeMap[feature.hotel.name] = feature.hotel.id;
      }
      await for (var feature in stub.listLiveaboards(liveaboardrequest)) {
        //print(feature.liveaboard.name);
        liveaboard.add(feature.liveaboard.name);
        liveaboardTypeMap[feature.liveaboard.name] = feature.liveaboard.id;
      }

      await for (var feature in stub.listTripTemplates(triptemplaterequest)) {
        // print(feature.template.name);
        triptemplateData.add(feature.template.name);
        triptemplateTypeMap[feature.template.name] = feature.template;
        // print('dd');
        // print(triptemplateData);
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

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

    // print(selectedTriptype);
    // print(triptemplate.tripType);
    if (eachTrip.tripTemplate.tripType == TripType.ONSHORE) {
      listroomrequest.hotelId = eachTrip.tripTemplate.hotelId;
    } else {
      listroomrequest.liveaboardId = eachTrip.tripTemplate.liveaboardId;
    }

    allRoom.clear();
    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        allRoom.add(feature.roomType);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return allRoom;
  }

  bool _showBoatField = false;

  void sendTripTemplateEdit() async {
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

    eachTrip.tripTemplate.address.addressLine1 = _controllerAddress.text;
    eachTrip.tripTemplate.address.addressLine2 = _controllerAddress2.text;
    eachTrip.tripTemplate.address.postcode = _controllerPostalcode.text;

    eachTrip.tripTemplate.address.city = _controllerCity.text;

    if (countrySelected != null) {
      eachTrip.tripTemplate.address.country = countrySelected;
    }
    if (regionSelected != null) {
      eachTrip.tripTemplate.address.region = regionSelected;
    }
    eachTrip.tripTemplate.description = _controllerDescription.text;
    eachTrip.tripTemplate.name = _controllerTripname.text;
    var address = Address();
    address.addressLine1 = eachTrip.tripTemplate.address.addressLine1;
    address.addressLine2 = eachTrip.tripTemplate.address.addressLine2;
    address.city = eachTrip.tripTemplate.address.city;

    address.postcode = eachTrip.tripTemplate.address.postcode;

    if (countrySelected != null) {
      address.country = countrySelected;
    }
    if (regionSelected != null) {
      address.region = regionSelected;
    }

    var triptemplate = TripTemplate()..address = address;
    triptemplate.description = eachTrip.tripTemplate.description;
    triptemplate.name = eachTrip.tripTemplate.name;
    triptemplate.boatId = eachTrip.tripTemplate.boatId;
    triptemplate.hotelId = eachTrip.tripTemplate.hotelId;
    triptemplate.liveaboardId = eachTrip.tripTemplate.liveaboardId;
    triptemplate.tripType = eachTrip.tripTemplate.tripType;


    final updateRequest = UpdateTripTemplateRequest()
      ..tripTemplate = eachTrip.tripTemplate;
    print(updateRequest);
    try {
      var response = await stub.updateTripTemplate(updateRequest);
      //print('response: ${response}');
      print('ok');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MainCompanyScreen(),
        ),
        (route) => false,
      );
      // print(token);
      // print(response);
    } on GrpcError catch (e) {
      // Handle exception of type GrpcError
      print('codeName: ${e.codeName}');
      print('details: ${e.details}');
      print('message: ${e.message}');
      print('rawResponse: ${e.rawResponse}');
      print('trailers: ${e.trailers}');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: <Widget>[],
            );
          });
    } catch (e) {
      // Handle all other exceptions
      print('Exception: $e');
    }
  }

  getHotelDetail() async {
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
    var hotelrequest = GetHotelRequest();
    hotelrequest.id = eachTrip.tripTemplate.hotelId;
    // print(hotelrequest.id);
    hotelDetial = await stub.getHotel(hotelrequest);
    return hotelDetial.hotel.name;
  }

  getLiveaboardDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = LiveaboardServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var liveaboardrequest = GetLiveaboardRequest();
    liveaboardrequest.id = eachTrip.tripTemplate.liveaboardId;
    liveaboardDetial = await stub.getLiveaboard(liveaboardrequest);

    return liveaboardDetial.liveaboard.name;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    //loadData();
    return Container(
      color: Color(0xfffd4f0f0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildTripNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildAddressFormField(),
          SizedBox(height: 20),
          buildAddress2FormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.6,
                // color: Colors.white,
                child: Center(
                    child: InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          countrySelected = country.name;
                          triptemplate.address.country = countrySelected;
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
                        : Text(eachTrip.tripTemplate.address.country),
                  ),
                )),
              ),
              Spacer(),
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
                // color: Colors.white,
                child: Center(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: regionSelected,
                    items: listRegion,
                    hint: Text(eachTrip.tripTemplate.address.region),
                    iconSize: 40,
                    validator: (value) {
                      setState(() {
                        triptemplate.address.region = regionSelected;
                      });
                      return null;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          regionSelected = value;
                          // triptemplate.address.region = regionSelected;

                          // print(value);
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

          DropdownButtonFormField(
            isExpanded: true,
            hint: Text(eachTrip.tripTemplate.tripType.toString()),
            iconSize: 40,
            onChanged: null,
          ),
          SizedBox(height: 20),
          eachTrip.tripTemplate.tripType == TripType.OFFSHORE
              ? FutureBuilder(
                  future: getLiveaboardDetail(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text(liveaboardDetial.liveaboard.name),
                          iconSize: 40,
                          onChanged: null,
                        ),
                      );
                    } else {
                      return Center(child: Text(''));
                    }
                  },
                )
              : FutureBuilder(
                  future: getHotelDetail(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text(hotelDetial.hotel.name),
                          iconSize: 40,
                          onChanged: null,
                        ),
                      );
                    } else {
                      return Center(child: Text(''));
                    }
                  },
                ),

          FutureBuilder(
            future: getRoomType(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                    width: 1110,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: allRoom.length,
                        itemBuilder: (BuildContext context, int index) {
                          _controllerPrice.add(new TextEditingController(
                              text: eachTrip.tripRoomTypePrices[index].price
                                  .toString()));
                          return Column(children: [
                            // Text(allRoom.length.toString()),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                allRoom[index].roomImages.length == 0
                                    ? new Container(
                                        width: 200,
                                        height: 200,
                                        color: Colors.blue,
                                      )
                                    : Container(
                                        width: 200,
                                        height: 200,
                                        child: Image.network(allRoom[index]
                                            .roomImages[0]
                                            .link
                                            .toString()),
                                      ),
                                SizedBox(width: 20),
                                Text(allRoom[index].name),
                                SizedBox(width: 20),
                                Text('Price : '),
                                SizedBox(width: 20),
                                Container(
                                  width: 50,
                                  child: TextFormField(
                                    controller: _controllerPrice[index],
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onSaved: (newValue) => price = newValue,
                                    onChanged: (value) {
                                      var roomprice2 = RoomTypeTripPrice();

                                      if (eachTrip.tripTemplate.tripType ==
                                          TripType.ONSHORE) {
                                        roomprice2.hotelId =
                                            eachTrip.tripTemplate.hotelId;
                                      } else {
                                        roomprice2.liveaboardId =
                                            eachTrip.tripTemplate.liveaboardId;
                                      }
                                      roomprice2.roomTypeId = allRoom[index].id;
                                      roomprice2.price = double.parse(value);
                                      if (count < allRoom.length) {
                                        roomPrice.add(roomprice2);
                                        count++;
                                      } else {
                                        roomPrice[index] = roomprice2;
                                      }
                                      // print(roomPrice);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ]);
                        }));
              } else {
                return Center(child: Text('No data'));
              }
            },
          ),
          SizedBox(height: 20),
          //boat
          Container(
            //color: Colors.white,
            child: Center(
              child: DropdownButtonFormField(
                  isExpanded: true,
                  value: boatSelected,
                  items: listBoat,
                  hint: eachTrip.tripTemplate.tripType == TripType.OFFSHORE
                      ? Text('no boat')
                      : Text(eachTrip.tripTemplate.boatId.toString()),
                  iconSize: 40,
                  onChanged: eachTrip.tripTemplate.tripType == TripType.OFFSHORE
                      ? null
                      : (value) {
                          setState(() {
                            boatSelected = value;

                            triptemplate.boatId = boatMap[boatSelected];
                          });
                        }),
            ),
          ),
          SizedBox(height: 20),
          Row(
            //Pic1
            children: [
              Center(
                  child: Pictrip == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(1);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip2 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip2.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip2.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(2);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip3 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip3.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip3.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(3);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip4 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip4.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip4.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(4);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip5 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip5.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip5.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(5);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Boatpic == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Boatpic.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Boatpic.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getBoatpic();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Schedule == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Schedule.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Schedule.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getSchedule();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () async => {
              await sendTripTemplateEdit(),
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

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        // print(value);

        setState(() {
          triptemplate.description = value;
        });
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTripNameFormField() {
    return TextFormField(
      controller: _controllerTripname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => tripname = newValue,
      onChanged: (value) {
        // print(triptemplate);
        // print(triptemplate.name);

        // print(value);

        setState(() {
          triptemplate.name = value;
        });
        return null;
      },
      decoration: InputDecoration(
        labelText: "Trip template name",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      onChanged: (value) {
        //  addressform.addressLine1 = value;
        //   print(addressform.addressLine1);

        setState(() {
          triptemplate.address.addressLine1 = value;
        });
        return null;
      },
      decoration: InputDecoration(
          //    hintText: "Address1",
          labelText: "Address 1",
          filled: true,
          fillColor: Color(0xfffd4f0f0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildAddress2FormField() {
    return TextFormField(
      controller: _controllerAddress2,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address2 = newValue,
      onChanged: (value) {
        // addressform.addressLine2 = value;

        setState(() {
          triptemplate.address.addressLine2 = value;
        });
        return null;
      },
      decoration: InputDecoration(
          //   hintText: "Address2",
          labelText: "Address 2",
          filled: true,
          fillColor: Color(0xfffd4f0f0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      controller: _controllerCity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        // addressform.city = value;

        setState(() {
          triptemplate.address.city = value;
        });
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "City",
        labelText: "City",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
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
      onChanged: (value) {
        //  addressform.postcode = value;

        setState(() {
          triptemplate.address.postcode = value;
        });
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Postal code",
        labelText: "Postal code",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
