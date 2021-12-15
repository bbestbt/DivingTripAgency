import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/screens/signup/company/staff_form.dart';
import 'package:flutter/material.dart';

class AddMoreStaff extends StatefulWidget {
   List<Staff> staffValue;
    AddMoreStaff( List<Staff> staffValue) {
    this.staffValue=staffValue;
  }
  @override
  _AddMoreStaffState createState() => _AddMoreStaffState(this.staffValue);
}

class _AddMoreStaffState extends State<AddMoreStaff> {
  int count = 1;
  List<Staff> staffValue;
    _AddMoreStaffState(List<Staff> staffValue) {
      this.staffValue=staffValue;
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
              return StaffForm(count.toString(),this.staffValue);
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              count += 1;
               staffValue.add(new Staff());
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
