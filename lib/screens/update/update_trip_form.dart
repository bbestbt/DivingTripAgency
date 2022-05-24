import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_trip/addDiveSite.dart';
import 'package:diving_trip_agency/screens/create_trip/trip_template.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/update_divemaster_in_trip.dart';
import 'package:diving_trip_agency/screens/update/update_divesite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:flutter/services.dart';

class updateEachTrip extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  TripWithTemplate eachTrip;
  updateEachTrip(TripWithTemplate eachTrip) {
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
                title: "Update Trip",
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
                          child: updateTripForm(this.eachTrip));
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

class updateTripForm extends StatefulWidget {
  TripWithTemplate eachTrip;
  updateTripForm(TripWithTemplate eachTrip) {
    this.eachTrip = eachTrip;
  }
  @override
  _updateTripFormState createState() => _updateTripFormState(this.eachTrip);
}

class _updateTripFormState extends State<updateTripForm> {
  TripWithTemplate eachTrip;
  _updateTripFormState(TripWithTemplate eachTrip) {
    this.eachTrip = eachTrip;
  }
  String divemastername;
  String price;
  String totalpeople;

  List<DropdownMenuItem<String>> listDivemaster = [];
  List<String> divemaster = [];
  String divemasterSelected;

  Map<String, dynamic> divemasterMap = {};
  TripTemplate triptemplate = new TripTemplate();
  Address addressform = new Address();


  final TextEditingController _controllerTotalpeople = TextEditingController();
  TextEditingController textarea = TextEditingController();

  DateTimeRange dateRange;
  DateTime from;
  DateTime to;
  DateTime last;
  List<DiveSite> pinkValue = [];
  final _formKey = GlobalKey<FormState>();
  String boatUsed = '';
  List<DiveMaster> dmValue = [];
  int pinkcount;
  List<DropdownMenuItem<String>> listTriptemplate = [];
  List<String> triptemplateData = [];
  String triptemplateSelected;
  Map<String, TripTemplate> triptemplateTypeMap = {};
  final TextEditingController _controllerName = TextEditingController();
  String name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _controllerTotalpeople.text = eachTrip.maxGuest.toString();
    textarea.text = eachTrip.schedule;
    dmValue = eachTrip.diveMasters;
    pinkValue = eachTrip.diveSites;
    _controllerName.text = eachTrip.name;
  }

  void loadData() async {
    //   boat.forEach((element) {
    //   print(element);
    // });
    await getData();
    setState(() {
      // listDivemaster = [];
      // listDivemaster = divemaster
      //     .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
      //     .toList();
      listTriptemplate = [];
      listTriptemplate = triptemplateData
          .map((val) => DropdownMenuItem<String>(
              child: Text(val.toString()), value: val.toString()))
          .toList();
    });

    // print(listBoat);
    // print(boat);
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

    var divemasterrequest = ListDiveMastersRequest();
    var triptemplaterequest = ListTripTemplatesRequest();

    try {
      // var response = await stub.listBoats(boatrequest);
      // print(token);
      // print(response);

      await for (var feature in stub.listDiveMasters(divemasterrequest)) {
        //  print(feature.diveMaster.firstName);
        divemaster.add(feature.diveMaster.firstName);
        divemasterMap[feature.diveMaster.firstName] = feature.diveMaster.id;
        //  print(divemaster);

      }
      await for (var feature in stub.listTripTemplates(triptemplaterequest)) {
        // print(feature.template.name);
        triptemplateData.add(feature.template.name);
        triptemplateTypeMap[feature.template.name] = feature.template;
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  void sendTripEdit() async {
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

    if (from != null) {
      eachTrip.startDate = Timestamp.fromDateTime(from);
    }

    if (to != null) {
      eachTrip.endDate = Timestamp.fromDateTime(to);
    }
    if (last != null) {
      eachTrip.lastReservationDate = Timestamp.fromDateTime(last);
    }
    if (triptemplateSelected != null) {
      // eachTrip.tripTemplate.name = triptemplateSelected;
      // eachTrip.tripTemplate.id = triptemplateTypeMap[triptemplateSelected];
      eachTrip.tripTemplate = triptemplateTypeMap[triptemplateSelected];
    }

    for (int i = 0; i < dmValue.length; i++) {
      eachTrip.diveMasters[i] = dmValue[i];
    }
    for (int j = 0; j < pinkValue.length; j++) {
      eachTrip.diveSites[j] = pinkValue[j];
    }
    for (int m = 0; m < roomPrice.length; m++) {
      var rp = RoomTypeTripPrice();
      rp.hotelId = roomPrice[m].hotelId;
      rp.price = roomPrice[m].price;
      rp.roomTypeId = roomPrice[m].roomTypeId;
      rp.liveaboardId = roomPrice[m].liveaboardId;

      eachTrip.tripRoomTypePrices.add(rp);
    }
    eachTrip.maxGuest = int.parse(_controllerTotalpeople.text);
    eachTrip.schedule = textarea.text;
    final updateRequest = UpdateTripRequest()..trip = eachTrip;
    print(updateRequest);
    try {
      var response = await stub.updateTrip(updateRequest);
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
      // if (e.codeName == 'UNAVAILABLE') {
      //   showError();
      //   print("this boat is already use");
      // }
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

  void getDMValue(dm) {
    setState(() {
      dmValue = dm;
    });
  }

  void getDSValue(ds) {
    setState(() {
      pinkValue = ds;
    });
  }

  List<TextEditingController> _controllerPrice = new List();
  List<RoomType> allRoom = [];
  List<RoomTypeTripPrice> roomPrice = [];
  getRoomTypeOld() async {
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
    if (eachTrip.tripTemplate.tripType == TripType.OFFSHORE) {
      listroomrequest.liveaboardId = eachTrip.tripTemplate.liveaboardId;
    } else {
      listroomrequest.hotelId = eachTrip.tripTemplate.hotelId;
    }

    allRoom.clear();
    _controllerPrice.clear();
    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        allRoom.add(feature.roomType);
        print('befotre if');
        if (eachTrip.tripRoomTypePrices.length <allRoom.length) {
          print('in if');
          eachTrip.tripRoomTypePrices.add(RoomTypeTripPrice());
          print('nn');
        }
      }
    } catch (e) {
      print('ERROR: $e');
    }
  
    return allRoom;
  }

  @override
  Widget build(BuildContext context) {
    //loadData();
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Text('From'),
              Spacer(),
              //  Text(from == null ? '' : from.toString()),
              Text(from == null
                  ? DateFormat("dd/MM/yyyy")
                      .format(eachTrip.startDate.toDateTime())
                  : DateFormat("dd/MM/yyyy").format(from)),
              Spacer(),
              RaisedButton(
                  color: Color(0xfff8dd9cc),
                  child: Text('Pick a date'),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2023))
                        .then((date) => {
                              if (date != null)
                                {
                                  setState(() {
                                    var timeStamp =
                                        print(Timestamp.fromDateTime(date));
                                    from = date;
                                  })
                                }
                            });
                  }),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('To'),
              Spacer(),
              // Text(to == null ? '' : to.toString()),
              Text(to == null
                  ? DateFormat("dd/MM/yyyy")
                      .format(eachTrip.endDate.toDateTime())
                  : DateFormat("dd/MM/yyyy").format(to)),
              Spacer(),
              RaisedButton(
                  color: Color(0xfff8dd9cc),
                  child: Text('Pick a date'),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: from,
                            firstDate: from,
                            lastDate: DateTime(2023))
                        .then((date) => {
                              if (date != null)
                                {
                                  setState(() {
                                    var timeStamp =
                                        print(Timestamp.fromDateTime(date));
                                    to = date;
                                  })
                                }
                            });
                  }),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last reservation date'),
                  Text('(last date is before trip one day)'),
                ],
              ),
              Spacer(),
              // Text(to == null ? '' : to.toString()),
              Text(last == null
                  ? DateFormat("dd/MM/yyyy")
                      .format(eachTrip.lastReservationDate.toDateTime())
                  : DateFormat("dd/MM/yyyy").format(last)),
              Spacer(),
              RaisedButton(
                  color: Color(0xfff8dd9cc),
                  child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 70.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: Center(child: Text('Pick a date'))),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: from.subtract(Duration(days: 1)))
                        .then((date) => {
                              if (date != null)
                                {
                                  setState(() {
                                    var timeStamp =
                                        print(Timestamp.fromDateTime(date));
                                    last = date;
                                  })
                                }
                            });
                  }),
            ],
          ),
          SizedBox(height: 20),

  
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xfffcafafe),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreDiveMasterUpdate(this.eachTrip, getDMValue),
          ),

          SizedBox(height: 20),
          buildTotalPeopleFormField(),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xfffb7e9f7),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreDiveSiteUpdate(
                this.pinkValue, this.eachTrip, getDSValue),
          ),
          SizedBox(height: 20),
          TextField(
            controller: textarea,
            keyboardType: TextInputType.multiline,
            maxLines: 20,
            // style: TextStyle(color: Colors. red),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.teal[50],
                hintText: "Enter schedule",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.blue),
                  // borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.redAccent))),
          ),
          SizedBox(height: 20),
          Container(
            color: Color(0xfffabddfc),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: triptemplateSelected,
                items: listTriptemplate,
                hint: Text(eachTrip.tripTemplate.name),
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
                      eachTrip.tripTemplate =
                          triptemplateTypeMap[triptemplateSelected];
                      eachTrip.tripRoomTypePrices.clear();
                      // print('l'+eachTrip.tripRoomTypePrices.length.toString());

                      // eachTrip.tripRoomTypePrices.length;
                      // triptemplate.name = triptemplateSelected;
                      // triptemplate.id =
                      //     triptemplateTypeMap[triptemplateSelected];
                    });
                  }
                },
              ),
            ),
          ),
          // SizedBox(height: 20),
          FutureBuilder(
            future: getRoomTypeOld(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Color(0xfffabddfc),
                  child: SizedBox(
                      width: 1110,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: allRoom.length,
                          itemBuilder: (BuildContext context, int index) {
                            // print('bf');
                            // print(_controllerPrice.length);
                            _controllerPrice.add(new TextEditingController(
                                text: eachTrip.tripRoomTypePrices[index].price
                                    .toString()
                                ));
                            // print('af');
                            // print(_controllerPrice.length);
                            // print('et');
                            // print(eachTrip.tripRoomTypePrices.length);

                            return Column(children: [
                              // Text('s')
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
                                          roomprice2.liveaboardId = eachTrip
                                              .tripTemplate.liveaboardId;
                                        }
                                        roomprice2.roomTypeId =
                                            allRoom[index].id;
                                        roomprice2.price = double.parse(value);

                                        // print(
                                        //     eachTrip.tripRoomTypePrices.length);
                                        if (eachTrip.tripRoomTypePrices.length <
                                            allRoom.length) {
                                          eachTrip.tripRoomTypePrices
                                              .add(roomprice2);
                                       
                                        } else {
                                          eachTrip.tripRoomTypePrices[index] =
                                              roomprice2;
                                        }
                                      },
                                    ),
                                  )
                                ],
                              )
                            ]);
                          })),
                );
              } else {
                return Center(child: Text('No data'));
              }
            },
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () async => {
              // print(dmValue),
              // print(pinkValue),
              await sendTripEdit(),
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

  TextFormField buildTotalPeopleFormField() {
    return TextFormField(
      controller: _controllerTotalpeople,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => totalpeople = newValue,
      decoration: InputDecoration(
        labelText: "Total people",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => name = newValue,
      decoration: InputDecoration(
        labelText: "Trip name",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
