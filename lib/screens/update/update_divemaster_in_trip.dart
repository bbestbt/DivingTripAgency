import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/room_form.dart';
import 'package:diving_trip_agency/screens/create_trip/divesite_form.dart';
import 'package:diving_trip_agency/screens/update/update_divemaster.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

var dmt;

class AddMoreDiveMasterUpdate extends StatefulWidget {
  List<DiveMaster> dmValue = [];
  List<String> divemaster = [];
  TripWithTemplate eachTrip;
  final customFunction;

  AddMoreDiveMasterUpdate(TripWithTemplate eachTrip, this.customFunction) {
    // this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    // this.divemaster = divemaster;
  }
  @override
  _AddMoreDiveMasterUpdateState createState() => _AddMoreDiveMasterUpdateState(
        // this.dmValue,
        this.eachTrip,
        // this.customFunction,
      );
}

class _AddMoreDiveMasterUpdateState extends State<AddMoreDiveMasterUpdate> {
  int dmcount = 0;
  TripWithTemplate eachTrip;
  // final customFunction;
  // List<String> divemaster = [];
  List<DiveMaster> dmValue = [];
  List<DiveMaster> allDivemaster = [];
  _AddMoreDiveMasterUpdateState(TripWithTemplate eachTrip) {
    // this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    // this.divemaster = divemaster;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDiveMasterInTrip();
  }

  getDiveMasterInTrip() async {
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
    var listdivemasterrequest = ListDiveMastersByTripRequest();
    listdivemasterrequest.tripId = eachTrip.id;

    allDivemaster.clear();
    try {
      await for (var feature
          in stub.listDiveMastersByTrip(listdivemasterrequest)) {
        allDivemaster.add(feature.diveMaster);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return allDivemaster;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 20,
        ),
        DiveMasterFormUpdate(
            dmcount, this.dmValue, this.eachTrip, widget.customFunction),
        Divider(
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
            shrinkWrap: true,
            itemCount: dmcount,
            itemBuilder: (BuildContext context, int index) {
              return DiveMasterForm(this.dmValue, this.eachTrip,
                  index + allDivemaster.length, widget.customFunction);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  dmcount += 1;
                  dmt = DiveMaster();
                  dmt.firstName = '';
                  dmt.id = Int64(0);

                  eachTrip.diveMasters.add(dmt);
                });
              },
              color: Color(0xfff55bcc9),
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
            // SizedBox(width: 30),
            // MaterialButton(
            //   onPressed: () {
            //     setState(() {
            //       if (eachTrip.diveMasters.length > 1) {
            //         // dmcount -= 1;
            //         eachTrip.diveMasters.removeLast();
            //         print(eachTrip.diveMasters);
            //       } else {
            //         dmcount = 0;
            //       }
            //     });
            //   },
            //   color: Color(0xfff55bcc9),
            //   textColor: Colors.white,
            //   child: Icon(
            //     Icons.remove,
            //     size: 20,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 30),
        // FlatButton(onPressed: () {
        //   print(eachTrip.diveMasters);
        // }),
      ])),
    );
  }
}

class DiveMasterFormUpdate extends StatefulWidget {
  int dmcount;
  List<DiveMaster> dmValue;
  TripWithTemplate eachTrip;
  List<String> divemaster = [];
  final customFunction;

  DiveMasterFormUpdate(int dmcount, List<DiveMaster> dmValue,
      TripWithTemplate eachTrip, this.customFunction) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    // this.divemaster = divemaster;
  }
  @override
  _DiveMasterFormUpdateState createState() => _DiveMasterFormUpdateState(
        this.dmcount,
        this.dmValue,
        this.eachTrip,
      );
}

class _DiveMasterFormUpdateState extends State<DiveMasterFormUpdate> {
  int dmcount;
  TripWithTemplate eachTrip;
  List<DiveMaster> dmValue;
  List<String> divemaster = [];
  List<DiveMaster> allDivemaster = [];

  _DiveMasterFormUpdateState(
      int dmcount, List<DiveMaster> dmValue, TripWithTemplate eachTrip) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    // this.divemaster = divemaster;
  }
  getDiveMasterInTrip() async {
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
    var listdivemasterrequest = ListDiveMastersByTripRequest();
    listdivemasterrequest.tripId = eachTrip.id;

    allDivemaster.clear();
    try {
      await for (var feature
          in stub.listDiveMastersByTrip(listdivemasterrequest)) {
        allDivemaster.add(feature.diveMaster);
      }
    } catch (e) {
      print('ERROR: $e');
    }
  
    // print(allDivemaster);
 
    return allDivemaster;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getDiveMasterInTrip(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  children: List.generate(
                    allDivemaster.length,
                    (index) => InfoCard(index, dmcount, dmValue, eachTrip,
                        widget.customFunction),
                  ));
            } else {
              return Center(child: Text('No divemaster'));
            }
          },
        ),
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  int index;
  int dmcount;
  List<DiveMaster> dmValue;
  List<String> divemaster = [];
  TripWithTemplate eachTrip;
  final customFunction;

  InfoCard(int index, int dmcount, List<DiveMaster> dmValue,
      TripWithTemplate eachTrip, this.customFunction) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    this.index = index;
    // this.divemaster = divemaster;
  }
  @override
  State<InfoCard> createState() => _InfoCardState(
        this.index,
        this.dmcount,
        this.dmValue,
        this.eachTrip,
      );
}

class _InfoCardState extends State<InfoCard> {
  int index;
  int dmcount;
  List<DiveMaster> dmValue;
  TripWithTemplate eachTrip;
  List<String> divemaster = [];
  List<DropdownMenuItem<String>> listDivemaster = [];
  int count = 0;
  _InfoCardState(this.index, this.dmcount, this.dmValue, this.eachTrip);
  void loadData() async {
    await getData();
    setState(() {
      listDivemaster = [];
      listDivemaster = divemaster
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();
    });
  }

  String divemasterSelected;
  Map<String, dynamic> divemasterMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
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
    // divemaster.clear();
    try {
      await for (var feature in stub.listDiveMasters(divemasterrequest)) {
        //  print(feature.diveMaster.firstName);
        divemaster.add(feature.diveMaster.firstName);
        divemasterMap[feature.diveMaster.firstName] = feature.diveMaster.id;
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Text(index.toString()),
          Container(
            color: Color(0xfffcafafe),
            // Colors.white,
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: divemasterSelected,
                items: listDivemaster,
                hint: Text(eachTrip.diveMasters[index].firstName),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      divemasterSelected = value;
                      divemaster.forEach((element) {
                        if (element == divemasterSelected) {
                          eachTrip.diveMasters[index].firstName =
                              divemasterSelected;
                          eachTrip.diveMasters[index].id =
                              divemasterMap[element];
                          widget.customFunction(eachTrip.diveMasters);
                          // print(eachTrip.diveMasters);
                        }
                      });

                      // print(value);
                    });
                  }
                  // print(dmValue);
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}

class DiveMasterForm extends StatefulWidget {
  int dmcount;
  List<DiveMaster> dmValue;
  List<String> divemaster = [];
  TripWithTemplate eachTrip;
  int indexForm;
  final customFunction;

  DiveMasterForm(List<DiveMaster> dmValue, TripWithTemplate eachTrip,
      int indexForm, this.customFunction) {
    // this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    // this.divemaster = divemaster;
    this.indexForm = indexForm;
  }
  @override
  _DiveMasterFormState createState() =>
      _DiveMasterFormState(this.dmValue, this.eachTrip, this.indexForm);
}

class _DiveMasterFormState extends State<DiveMasterForm> {
  int dmcount;
  int indexForm;
  List<DiveMaster> dmValue = [];
  List<String> divemaster = [];
  TripWithTemplate eachTrip;
  _DiveMasterFormState(
      List<DiveMaster> dmValue, TripWithTemplate eachTrip, int indexForm) {
    // this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    // this.divemaster = divemaster;
    this.indexForm = indexForm;
  }
  List<DropdownMenuItem<String>> listDivemaster = [];
  String divemasterSelected;
  Map<String, dynamic> divemasterMap = {};

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
      await for (var feature in stub.listDiveMasters(divemasterrequest)) {
        divemaster.add(feature.diveMaster.firstName);
        divemasterMap[feature.diveMaster.firstName] = feature.diveMaster.id;
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  void loadData() async {
    await getData();
    setState(() {
      listDivemaster = [];
      listDivemaster = divemaster
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Text(indexForm.toString()),
          Container(
            color: Color(0xfffcafafe),
            // Colors.pink,
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: divemasterSelected,
                items: listDivemaster,
                hint: Text('  Select dive master'),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      divemasterSelected = value;
                      // dmValue = eachTrip.diveMasters;
                      // print(dmValue);
                      divemaster.forEach((element) {
                        if (element == divemasterSelected) {
                          // print(eachTrip.diveMasters.length);

                          // var dm2 = DiveMaster();
                          dmt.firstName = divemasterSelected;
                          dmt.id = divemasterMap[element];
                          // eachTrip.diveMasters[indexForm] = dm2;
                          eachTrip.diveMasters[indexForm]=dmt;
                          widget.customFunction(eachTrip.diveMasters);

                          //------

                          // dmValue[0].id = divemasterMap[element];
                          // dmValue[0].firstName = divemasterSelected;
                          // eachTrip.diveMasters.addAll(dmValue);
                          //------

                          // eachTrip.diveMasters[indexForm].firstName =
                          //     divemasterSelected;
                          // eachTrip.diveMasters[indexForm].id =
                          //     divemasterMap[element];

                          // print(eachTrip.diveMasters);
                        }
                      });
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}
