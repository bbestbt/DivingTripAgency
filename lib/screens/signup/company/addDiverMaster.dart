import 'package:diving_trip_agency/screens/signup/company/divermaster_form.dart';
import 'package:flutter/material.dart';

class AddmoreDiverMaster extends StatefulWidget {
  @override
  _AddmoreDiverMasterState createState() => _AddmoreDiverMasterState();
}

class _AddmoreDiverMasterState extends State<AddmoreDiverMaster> {
  int count = 1;
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
              return DiveMasterForm(count.toString());
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              count += 1;
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
