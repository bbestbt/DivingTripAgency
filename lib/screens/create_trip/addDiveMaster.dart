import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/room_form.dart';
import 'package:diving_trip_agency/screens/create_trip/divesite_form.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

class AddMoreDiveMaster extends StatefulWidget {
  List<DiveMaster> dmValue = [];
  List<String> errors = [];

  AddMoreDiveMaster(List<DiveMaster> dmValue, List<String> errors) {
    this.dmValue = dmValue;
    this.errors = errors;
  }
  @override
  _AddMoreDiveMasterState createState() =>
      _AddMoreDiveMasterState(this.dmValue, this.errors);
}

class _AddMoreDiveMasterState extends State<AddMoreDiveMaster> {
  int dmcount = 1;
  List<String> errors = [];
  List<DiveMaster> dmValue = [];
  _AddMoreDiveMasterState(List<DiveMaster> dmValue, List<String> errors) {
    this.dmValue = dmValue;
    this.errors = errors;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 20,
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
              return DiveMasterForm(dmcount, this.dmValue, this.errors);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  dmcount += 1;
                  dmValue.add(new DiveMaster());
                });
              },
              color: Color(0xfff55bcc9),
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
                  dmcount -= 1;
                  dmValue.remove(new DiveMaster());
                });
              },
              color: Color(0xfff55bcc9),
              textColor: Colors.white,
              child: Icon(
                Icons.remove,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ])),
    );
  }
}

class DiveMasterForm extends StatefulWidget {
  int dmcount;
  List<DiveMaster> dmValue;
  List<String> errors = [];

  DiveMasterForm(int dmcount, List<DiveMaster> dmValue, List<String> errors) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.errors = errors;
    // this.blueValue = blueValue;
  }
  @override
  _DiveMasterFormState createState() =>
      _DiveMasterFormState(this.dmcount, this.dmValue, this.errors);
}

class _DiveMasterFormState extends State<DiveMasterForm> {
  int dmcount;

  List<DiveMaster> dmValue;
  List<String> errors = [];
  _DiveMasterFormState(
      int dmcount, List<DiveMaster> dmValue, List<String> errors) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.errors = errors;
  }
  List<DropdownMenuItem<String>> listDivemaster = [];
  List<String> divemaster = [];
  String divemasterSelected;
  Map<String, dynamic> divemasterMap = {};
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
          Container(
            color: Color(0xfffcafafe),
            // Colors.white,
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: divemasterSelected,
                items: listDivemaster,
                hint: Text('  Select dive master'),
                iconSize: 40,
                validator: (value) {
                  if (value == null) {
                    addError(error: "Please select dive master");
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    removeError(error: "Please select dive master");
                    setState(() {
                      divemasterSelected = value;
                      divemaster.forEach((element) {
                        if (element == divemasterSelected) {
                          // print(amenityMap[element]);
                          dmValue[dmcount - 1].firstName = divemasterSelected;
                          dmValue[dmcount - 1].id = divemasterMap[element];
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
