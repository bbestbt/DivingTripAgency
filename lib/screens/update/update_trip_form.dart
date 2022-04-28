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

  // final TextEditingController _controllerDivemastername =
  //     TextEditingController();
  // final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerTotalpeople = TextEditingController();

  DateTimeRange dateRange;
  DateTime from;
  DateTime to;
  DateTime last;
  List<DiveSite> pinkValue = [new DiveSite()];
  final _formKey = GlobalKey<FormState>();
  String boatUsed = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _controllerTotalpeople.text = eachTrip.maxGuest.toString();
  }

  void loadData() async {
    //   boat.forEach((element) {
    //   print(element);
    // });
    await getData();
    setState(() {
      listDivemaster = [];
      listDivemaster = divemaster
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
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
    } catch (e) {
      print('ERROR: $e');
    }
  }

  showError() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Boat is already used"),
            actions: <Widget>[
              FlatButton(
                  //child: Text("OK"),
                  ),
            ],
          );
        });
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
            color: Colors.white,
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: divemasterSelected,
                items: listDivemaster,
                hint: Text('eachTrip.diveMasters'),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      divemasterSelected = value;
                      print(value);
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),

          buildTotalPeopleFormField(),
          SizedBox(height: 20),
          // Container(
          //   width: MediaQuery.of(context).size.width / 1.5,
          //   decoration: BoxDecoration(
          //       color: Color(0xffffee1e8),
          //       borderRadius: BorderRadius.circular(10)),
          //   child: AddMoreDiveSite(this.pinkValue, this.errors),
          // ),
          SizedBox(height: 20),
          // Container(
          //     width: MediaQuery.of(context).size.width / 1.5,
          //     decoration: BoxDecoration(
          //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
          //     child: Triptemplate(this.triptemplate, this.errors)),

          SizedBox(height: 20),

          FlatButton(
            //onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))},
            onPressed: () async => {
              // await AddTrip(),
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
}