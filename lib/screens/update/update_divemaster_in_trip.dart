import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/room_form.dart';
import 'package:diving_trip_agency/screens/create_trip/divesite_form.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

class AddMoreDiveMasterUpdate extends StatefulWidget {
  List<DiveMaster> dmValue = [];
  List<String> divemaster = [];
  TripWithTemplate eachTrip;

  AddMoreDiveMasterUpdate(List<DiveMaster> dmValue, TripWithTemplate eachTrip,
      List<String> divemaster) {
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    this.divemaster = divemaster;
    //  print('a');
    // print(divemaster);
    //  print('b');
  }
  @override
  _AddMoreDiveMasterUpdateState createState() => _AddMoreDiveMasterUpdateState(
      this.dmValue, this.eachTrip, this.divemaster);
}

class _AddMoreDiveMasterUpdateState extends State<AddMoreDiveMasterUpdate> {
  int dmcount = 1;
  TripWithTemplate eachTrip;
  List<String> divemaster = [];
  List<DiveMaster> dmValue = [];
  _AddMoreDiveMasterUpdateState(List<DiveMaster> dmValue,
      TripWithTemplate eachTrip, List<String> divemaster) {
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    this.divemaster = divemaster;
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
              return DiveMasterFormUpdate(
                  dmcount, this.dmValue, this.eachTrip, this.divemaster);
            }),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     MaterialButton(
        //       onPressed: () {
        //         setState(() {
        //           dmcount += 1;
        //           dmValue.add(new DiveMaster());
        //         });
        //       },
        //       color: Color(0xfff55bcc9),
        //       textColor: Colors.white,
        //       child: Icon(
        //         Icons.add,
        //         size: 20,
        //       ),
        //     ),
        //     SizedBox(width: 30),
        //     MaterialButton(
        //       onPressed: () {
        //         setState(() {
        //           dmcount -= 1;
        //           dmValue.remove(new DiveMaster());
        //         });
        //       },
        //       color: Color(0xfff55bcc9),
        //       textColor: Colors.white,
        //       child: Icon(
        //         Icons.remove,
        //         size: 20,
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(height: 30),
      ])),
    );
  }
}

class DiveMasterFormUpdate extends StatefulWidget {
  int dmcount;
  List<DiveMaster> dmValue;
  TripWithTemplate eachTrip;
  List<String> divemaster = [];
  DiveMasterFormUpdate(int dmcount, List<DiveMaster> dmValue,
      TripWithTemplate eachTrip, List<String> divemaster) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    this.divemaster = divemaster;
  }
  @override
  _DiveMasterFormUpdateState createState() => _DiveMasterFormUpdateState(
      this.dmcount, this.dmValue, this.eachTrip, this.divemaster);
}

class _DiveMasterFormUpdateState extends State<DiveMasterFormUpdate> {
  int dmcount;
  TripWithTemplate eachTrip;
  List<DiveMaster> dmValue;
  List<String> divemaster = [];

  _DiveMasterFormUpdateState(int dmcount, List<DiveMaster> dmValue,
      TripWithTemplate eachTrip, this.divemaster) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    this.divemaster = divemaster;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 20,
        runSpacing: 40,
        children: List.generate(
         divemaster.length,
          (index) => InfoCard(index, dmcount, dmValue, eachTrip, divemaster),
        ));
  }
}

class InfoCard extends StatefulWidget {
  int index;
  int dmcount;
  List<DiveMaster> dmValue;
  List<String> divemaster = [];
  TripWithTemplate eachTrip;
  InfoCard(int index, int dmcount, List<DiveMaster> dmValue,
      TripWithTemplate eachTrip, List<String> divemaster) {
    this.dmcount = dmcount;
    this.dmValue = dmValue;
    this.eachTrip = eachTrip;
    this.index = index;
    this.divemaster = divemaster;
  }
  @override
  State<InfoCard> createState() => _InfoCardState(
      this.index, this.dmcount, this.dmValue, this.eachTrip, this.divemaster);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  int dmcount;
  List<DiveMaster> dmValue;
  TripWithTemplate eachTrip;
  List<String> divemaster = [];
  _InfoCardState(
      this.index, this.dmcount, this.dmValue, this.eachTrip, this.divemaster);
  void loadData() async {
    setState(() {
      listDivemaster = [];
      listDivemaster = divemaster
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();
    });
  }

  List<DropdownMenuItem<String>> listDivemaster = [];

  String divemasterSelected;
  Map<String, dynamic> divemasterMap = {};

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
                hint: Text(divemaster[index]),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
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
