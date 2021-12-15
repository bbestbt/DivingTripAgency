import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/screens/signup/company/divermaster_form.dart';
import 'package:flutter/material.dart';

class AddmoreDiverMaster extends StatefulWidget {
     List<DiveMaster> divemasterValue;
    AddmoreDiverMaster( List<DiveMaster> divemasterValue) {
    this.divemasterValue=divemasterValue;
  }
  @override
  _AddmoreDiverMasterState createState() => _AddmoreDiverMasterState(this.divemasterValue);
}

class _AddmoreDiverMasterState extends State<AddmoreDiverMaster> {
  int count = 1;
  List<DiveMaster> divemasterValue;
    _AddmoreDiverMasterState(List<DiveMaster> divemasterValue) {
      this.divemasterValue=divemasterValue;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return DiveMasterForm(count.toString(),this.divemasterValue);
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              count += 1;
               divemasterValue.add(new DiveMaster());
            });
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 20,
          ),
        ),
         SizedBox(height: 30),
      ])),
    );
  }
}
