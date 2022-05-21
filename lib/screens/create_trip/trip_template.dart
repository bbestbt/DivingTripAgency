import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';

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

class Triptemplate extends StatefulWidget {
  TripTemplate triptemplate;
  List<RoomTypeTripPrice> roomPrice = [];
  // HotelAndBoatId hotelandboatID = new HotelAndBoatId();
  Address addressform = new Address();
  List<String> errors = [];
  bool switchVal=false;
final customFunction;
  Triptemplate(TripTemplate triptemplate, List<String> errors,
      List<RoomTypeTripPrice> roomPrice, this.customFunction) {
    this.triptemplate = triptemplate;
    // this.triptemplate.hotelAndBoatId = hotelandboatID;
    this.triptemplate.address = addressform;
    this.errors = errors;
    this.roomPrice = roomPrice;
    this.switchVal = switchVal;
    // this.customFunction=customFunction;
  }
  @override
  _TriptemplateState createState() => _TriptemplateState(
      this.triptemplate, this.errors, this.roomPrice, this.switchVal);
}

class _TriptemplateState extends State<Triptemplate> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
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

  List<String> errors = [];
  String triptype = '';
  String boatname;
  TripTemplate triptemplate;
  // HotelAndBoatId hotelandboatID = new HotelAndBoatId();
  Address addressform = new Address();
  _TriptemplateState(TripTemplate triptemplate, List<String> errors,
      List<RoomTypeTripPrice> roomPrice,this.switchValue) {
    this.triptemplate = triptemplate;
    // this.triptemplate.hotelAndBoatId = hotelandboatID;
    this.addressform = addressform;
    this.errors = errors;
    this.roomPrice = roomPrice;
    this.switchValue = switchValue;
  }
  final TextEditingController _controllerTripname = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerBoatname = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerAddress2 = TextEditingController();
  final TextEditingController _controllerPostalcode = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerRegion = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  // final TextEditingController _controllerPrice = TextEditingController();
  List<TextEditingController> _controllerPrice = new List();
  List<RoomType> allRoom = [];
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

  // Widget buildGridView() {
  // return Column(
  // children:[
  // Text("Gallery here:"),
  //Container(
  //height:100,
  //width:400,
  //             child:
  //  GridView.count(
  //  crossAxisCount: 3,
  //children: List.generate(imagelist.length, (index) {
  //Asset asset = imagelist[index];
  //return AssetThumb(
  // asset: asset,
  //width: 20,
  //height: 20,
  //);
  //}),
  //)
  //),

  // ]
  //) ;
  //}

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
        triptemplateTypeMap[feature.template.name] = feature.template.id;
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
    if (selectedTriptype == '0') {
      listroomrequest.hotelId = hotelTypeMap[selectedsleep];
    } else {
      listroomrequest.liveaboardId = liveaboardTypeMap[selectedsleep];
    }

    allRoom.clear();
    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        allRoom.add(feature.roomType);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('--');
    // roomPrice = new List(allRoom.length);
    // print(allRoom);
    return allRoom;
  }

  bool _showTextField = false;
  bool _showBoatField = false;
  List<DropdownMenuItem<String>> listTriptemplate = [];
  List<String> triptemplateData = [];
  String triptemplateSelected;
  Map<String, dynamic> triptemplateTypeMap = {};
  bool isVisibleOld = false;
  bool isVisibleNew = true;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    //loadData();
    // getData();
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     FlatButton(
        //       onPressed: () => setState(() => isVisibleOld = !isVisibleOld),
        //       color: Color(0xfffa2c8ff),
        //       child: Text(
        //         'Create from old triptemplate',
        //         style: TextStyle(fontSize: 15),
        //       ),
        //     ),
        //     FlatButton(
        //       onPressed: () => setState(() => isVisibleNew = !isVisibleNew),
        //       color: Color(0xfffd4f0f0),
        //       child: Text(
        //         'Create new triptemplate',
        //         style: TextStyle(fontSize: 15),
        //       ),
        //     ),
        //   ],
        // ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create new triptemplate'),
              Switch(
                value: switchValue,
                onChanged: (value) {
                  switchValue = value;
                  isVisibleNew = !isVisibleNew;
                  isVisibleOld = !isVisibleOld;
                  setState(() {
                       switchValue = value;
                       print(switchValue);
                       widget.customFunction(switchValue);
                  });
                },
              ),
              Text('Create from old triptemplae'),
            ],
          ),
        ),
        // FlatButton(onPressed: () {
        //   print(switchValue);
        // }),
        // SizedBox(height: 20),
        Visibility(
          visible: isVisibleOld,
          child: Container(
            color: Color(0xfffabddfc),
            // Color(0xfffa2c8ff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: triptemplateSelected,
                items: listTriptemplate,
                hint: Text('  Select trip template'),
                iconSize: 40,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      triptemplateSelected = value;
                      // print(triptemplateSelected);
                      // print(value);
                      // print(triptemplate);
                      triptemplate.name = triptemplateSelected;
                      triptemplate.id =
                          triptemplateTypeMap[triptemplateSelected];
                      // print(triptemplate.name);
                      // print(triptemplate.id);
                    });
                  }
                  // print(triptemplateSelected);
                },
              ),
            ),
          ),
        ),

        SizedBox(height: 20),
        Visibility(
          visible: isVisibleNew,
          child: Container(
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
                        child:
                        InkWell(
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
                            child: countrySelected != null ? Text(countrySelected) : null,
                          ),
                        )

                        /*DropdownButtonFormField(
                          isExpanded: true,
                          value: countrySelected,
                          items: listCountry,
                          hint: Text('  Select country'),
                          iconSize: 40,
                          validator: (value) {
                            if (value == null) {
                              addError(error: "Please select country");
                              return "";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              removeError(error: "Please select country");
                              setState(() {
                                countrySelected = value;
                                triptemplate.address.country = countrySelected;
                                // print(value);
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
                      // color: Colors.white,
                      child: Center(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          value: regionSelected,
                          items: listRegion,
                          hint: Text('  Select region'),
                          iconSize: 40,
                          validator: (value) {
                            if (value == null) {
                              addError(error: "Please select region");
                              return "";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              removeError(error: "Please select region");
                              setState(() {
                                regionSelected = value;
                                triptemplate.address.region = regionSelected;

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

                // buildBoatNameFormField(),
                // SizedBox(height: 20),
                //radio
                // Row(children: [
                //   Text('Trip Type '),
                //   Spacer(),
                // ]),
                // Row(children: [
                //   Radio(
                //       value: 'On shore (Hotel)',
                //       groupValue: triptype,
                //       onChanged: (val) {
                //         // triptype = val;
                //         setState(() {
                //            triptype = val;
                //             print(val);

                //         });
                //       }),
                //   Text('On shore (Hotel)'),
                // ]),

                // Row(
                //   children: [
                //     Radio(
                //         value: 'Off shore (Live on boat)',
                //         groupValue: triptype,
                //         onChanged: (val) {
                //           // triptype = val;
                //           setState(() {
                //              triptype = val;
                //               print(val);
                //           });
                //         }),
                //     Text('Off shore (Live on boat)'),
                //   ],
                // ),

                // Container(
                //   color: Color(0xfffd4f0f0),
                //   child: Center(
                //     child: DropdownButton(
                //       isExpanded: true,
                //       value: selected,
                //       items: listTrip,
                //       hint: Text('  Select trip type'),
                //       iconSize: 40,
                //       onChanged: (value) {
                //         setState(() {
                //           selected = value;
                //           TripType.values.forEach((tripType) {
                //             if (tripTypeMap[tripType.toString()] ==
                //                 int.parse(selected)) {
                //               triptemplate.tripType = tripType;
                //             }
                //           });
                //           print(value);
                //         });
                //       },
                //     ),
                //   ),
                // ),

                DropdownButtonFormField(
                  hint: Text('Trip type'),
                  value: selectedTriptype,
                  isExpanded: true,
                  items: listTrip,
                  validator: (value) {
                    if (value == null) {
                      addError(error: "Please select trip type");
                      return "";
                    }
                    return null;
                  },
                  onChanged: (trip_type) {
                    if (trip_type != null) {
                      removeError(error: "Please select trip type");
                      if (trip_type == '0') {
                        triptypee = hotel;
                        _showBoatField = true;
                      } else if (trip_type == '1') {
                        triptypee = liveaboard;
                      } else {
                        // print('x');
                        // print(trip_type);
                        // print(trip_type.runtimeType);
                        triptypee = [];
                      }
                      setState(() {
                        // print(triptypee);
                        // print('--');
                        selectedTriptype = trip_type;
                        selectedsleep = null;
                        TripType.values.forEach((tripType) {
                          if (tripTypeMap[tripType.toString()] ==
                              int.parse(selectedTriptype)) {
                            triptemplate.tripType = tripType;
                          }
                        });
                      });
                    }
                    // print('*');
                    // print(trip_type);
                    // print('*');
                    // if (trip_type ==0 ) {
                    //   triptypee = liveaboard;
                    // } else if (trip_type == 1) {
                    //   triptypee = hotel;
                    // }
                    // else {
                    //   triptypee = [];
                    // }
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedsleep,
                  hint: Text('Residence'),
                  isExpanded: true,
                  items: triptypee.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      addError(error: "Please select name");
                      return "";
                    }
                    return null;
                  },
                  onTap: () {
                    roomPrice.clear();
                    count = 0;
                  },
                  onChanged: (sleep) {
                    if (sleep != null) {
                      removeError(error: "Please select name");
                      setState(() {
                        selectedsleep = sleep;
                        if (triptypee == liveaboard) {
                          // print('liveabaord');
                          // print(liveaboardTypeMap[selectedsleep]);
                          triptemplate.liveaboardId =
                              liveaboardTypeMap[selectedsleep];
                          // print('keep');
                          // print( triptemplate.liveaboardId);
                          _showTextField = true;
                        } else if (triptypee == hotel) {
                          // print('hotel');
                          // print(hotelTypeMap[selectedsleep]);

                          triptemplate.hotelId = hotelTypeMap[selectedsleep];
                          _showTextField = true;

                          // hotelandboatID.hotelId = hotelTypeMap[selectedsleep];
                          //  triptemplate.hotelAndBoatId=hotelandboatID;
                          //   triptemplate.hotelAndBoatId.hotelId= hotelTypeMap[selectedsleep];
                        }
                        // showRoom(context);
                        // getRoomType();
                      });
                    }
                  },
                ),
                Visibility(
                  visible: _showTextField,
                  child: FutureBuilder(
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
                                  _controllerPrice
                                      .add(new TextEditingController());
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
                                                child: Image.network(
                                                    allRoom[index]
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
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onSaved: (newValue) =>
                                                price = newValue,
                                            onChanged: (value) {
                                              // print(index);
                                              // print(value);
                                              // print(roomPrice);
                                              // for (int i = 0;
                                              //     i < allRoom.length;
                                              //     i++) {

                                              // var roomprice2 =
                                              //     RoomTypeTripPrice();

                                              // if (selectedTriptype == '0') {
                                              //   roomprice2.hotelId =
                                              //       hotelTypeMap[selectedsleep];
                                              // } else {
                                              //   roomprice2.liveaboardId =
                                              //       liveaboardTypeMap[
                                              //           selectedsleep];
                                              // }
                                              // roomprice2.roomTypeId =
                                              //     allRoom[index].id;
                                              // roomprice2.price =
                                              //     double.parse(value);
                                              // roomPrice[index] = roomprice2;

                                              // }
                                              // print(roomPrice);

                                              var roomprice2 =
                                                  RoomTypeTripPrice();

                                              if (selectedTriptype == '0') {
                                                roomprice2.hotelId =
                                                    hotelTypeMap[selectedsleep];
                                              } else {
                                                roomprice2.liveaboardId =
                                                    liveaboardTypeMap[
                                                        selectedsleep];
                                              }
                                              roomprice2.roomTypeId =
                                                  allRoom[index].id;
                                              roomprice2.price =
                                                  double.parse(value);
                                              if (count < allRoom.length) {
                                                roomPrice.add(roomprice2);
                                                count++;
                                              } else {
                                                roomPrice[index] = roomprice2;
                                              }
                                              // print(roomPrice);

                                              if (value.isNotEmpty) {
                                                removeError(
                                                    error:
                                                        "Please enter price");
                                              }
                                              return null;
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                addError(
                                                    error:
                                                        "Please enter price");
                                                return "";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ]);
                                })

                            //  Wrap(
                            //     spacing: 20,
                            //     runSpacing: 40,
                            //     children: List.generate(
                            //         allRoom.length,
                            //         (index) => Column(
                            //               children: [
                            //                 // Text(allRoom.length.toString()),
                            //                 SizedBox(height: 20),
                            //                 Row(
                            //                   children: [
                            //                     Container(
                            //                       width: 200,
                            //                       height: 200,
                            //                       child: Image.network(
                            //                           allRoom[index]
                            //                               .roomImages[0]
                            //                               .link
                            //                               .toString()),
                            //                     ),
                            //                     SizedBox(width: 20),
                            //                     Text('Price : '),
                            //                     SizedBox(width: 20),

                            //                             // buildPriceFormField()),
                            //                   ],
                            //                 )
                            //                 // SizedBox(height: 20),
                            //               ],
                            //             )))
                            );
                      } else {
                        return Center(child: Text('No data'));
                      }
                    },
                  ),
                ),

                SizedBox(height: 20),

                Visibility(
                  visible: _showBoatField,
                  child: Container(
                    //color: Colors.white,
                    child: Center(
                      child: DropdownButtonFormField(
                          isExpanded: true,
                          value: boatSelected,
                          items: listBoat,
                          //     boat.map((String value) {
                          //   return DropdownMenuItem<String>(
                          //     value: value,
                          //     child: Text(value),
                          //   );
                          // }).toList(),

                          hint: Text('  Select boat (ONSHORE)'),
                          iconSize: 40,
                          // validator: (value) {
                          //   if (value == null) {
                          //     addError(error: "Please select boat");
                          //     return "";
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) {
                            // if (value != null) {
                            //   removeError(error: "Please select boat");
                            setState(() {
                              boatSelected = value;
                              // print(value);
                              //  hotelandboatID.boatId = boatMap[boatSelected];

                              triptemplate.boatId = boatMap[boatSelected];

                              // triptemplate.hotelAndBoatId=hotelandboatID;
                              //   triptemplate.divingBoatId=boatMap[boatSelected];
                            });
                          }
                          // },
                          ),
                    ),
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

                // FormError(errors: errors),

                SizedBox(height: 20),

                //Container(
                // child:

                //buildGridView(),

                // )

                // FlatButton(onPressed: () {
                //   print(switchValue);
                // }),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        triptemplate.description = value;
        // print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter Description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter Description");
          return "";
        }
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

        triptemplate.name = value;
        // print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter trip name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter trip name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Trip name",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // TextFormField buildBoatNameFormField() {
  //   return TextFormField(
  //     controller: _controllerBoatname,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => boatname = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please Enter boat name");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please Enter boat name");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Boat name",
  //       filled: true,
  //       fillColor: Color(0xfffd4f0f0),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      onChanged: (value) {
        //  addressform.addressLine1 = value;
        //   print(addressform.addressLine1);
        triptemplate.address.addressLine1 = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
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
        triptemplate.address.addressLine2 = value;

        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
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

  TextFormField buildCountryFormField() {
    return TextFormField(
      controller: _controllerCountry,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        triptemplate.address.country = value;
        // addressform.country = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter country");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter country");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Country",
        labelText: "Country",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      controller: _controllerCity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        // addressform.city = value;
        triptemplate.address.city = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter city");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter city");
          return "";
        }
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

  TextFormField buildRegionFormField() {
    return TextFormField(
      controller: _controllerRegion,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => region = newValue,
      onChanged: (value) {
        triptemplate.address.region = value;
        //  addressform.region = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter region");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter region");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //    hintText: "Region",
        labelText: "Region",
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
        triptemplate.address.postcode = value;
        //  addressform.postcode = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter postal code");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter postal code");
          return "";
        }
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

  // TextFormField buildPriceFormField() {
  //   return TextFormField(
  //     controller: _controllerPrice,
  //     keyboardType: TextInputType.number,
  //     inputFormatters: [
  //       FilteringTextInputFormatter.digitsOnly,
  //     ],
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => price = newValue,
  //     onChanged: (value) {
  //       // roomPrice.price=double.parse(value);
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please enter price");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please enter price");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       //   hintText: "Postal code",
  //       // labelText: "Price",
  //       filled: true,
  //       fillColor: Color(0xfffd4f0f0),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }
}
