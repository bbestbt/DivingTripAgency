import 'package:diving_trip_agency/screens.dart/signup/company/staff_form.dart';
import 'package:flutter/material.dart';

class AddMoreStaff extends StatefulWidget {
  @override
  _AddMoreStaffState createState() => _AddMoreStaffState();
}

class _AddMoreStaffState extends State<AddMoreStaff> {
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
              return StaffForm(count.toString());
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
      ])),
    );
  }
}
