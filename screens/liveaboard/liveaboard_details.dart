import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class LiveaboardDetailScreen extends StatelessWidget {
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
        SectionTitle(
          title: "Liveaboard",
          color: Color(0xFFFF78a2cc),
        ),
        Text("Liveaboard name : eiusmod tempor"),
        SizedBox(
          height: 20,
        ),
        Text("Address : Lorem ipsum dolor sit ametm"),
        SizedBox(
          height: 20,
        ),
        Image.asset("assets/images/S__77242370.jpg"),
        SizedBox(
          height: 20,
        ),
        Text(
            'Description : sed do eiusmod tempor incididunt ut labore et dolore'),
        SizedBox(
          height: 20,
        ),
        Text('Length: 9'),
        SizedBox(
          height: 20,
        ),
        Text('Width: 7'),
        SizedBox(
          height: 20,
        ),
        Text('Total capacity : 25'),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(0xFFFF8edfff),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/images/S__77242370.jpg"),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Room type : Single Room'),
              SizedBox(
                height: 20,
              ),
              Text(
                  'Room description : Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore'),
              SizedBox(
                height: 20,
              ),
              Text('Max capacity : 3'),
              SizedBox(
                height: 20,
              ),
              Text('Room quantity : 10'),
              SizedBox(height: 20),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              Text('Price : 39,000'),
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
