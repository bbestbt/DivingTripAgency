import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class DiveResortDetailScreen extends StatelessWidget {
  final MenuController _controller = Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _controller.scaffoldkey,
        drawer: SideMenu(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Header(),
                SizedBox(height: 30),
                detail(),
              ],
            ),
          ),
        ));
  }
}

class detail extends StatelessWidget {
  const detail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Hotel name"),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('phone number'),
            SizedBox(width: 30),
            Text("address")
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Image.asset("assets/images/S__77242370.jpg"),
        SizedBox(
          height: 20,
        ),
        Text('description'),
        SizedBox(
          height: 20,
        ),
        Image.asset("assets/images/S__77242370.jpg"),
        SizedBox(
          height: 20,
        ),
        Text('Room type'),
        SizedBox(
          height: 20,
        ),
        Text('Room description'),
        SizedBox(
          height: 20,
        ),
        Text('Max capacity'),
        SizedBox(
          height: 20,
        ),
        Text('Room quantity'),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              Text('Price'),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {},
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text("Book"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
