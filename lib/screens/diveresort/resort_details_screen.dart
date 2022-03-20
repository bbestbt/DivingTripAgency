import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class DiveResortDetailScreen extends StatefulWidget {
  int index;
  List<TripWithTemplate> details;
  DiveResortDetailScreen(int index, List<TripWithTemplate> details) {
    this.details = details;
    this.index = index;
  }

  @override
  State<DiveResortDetailScreen> createState() =>
      _DiveResortDetailScreenState(this.index, this.details);
}

class _DiveResortDetailScreenState extends State<DiveResortDetailScreen> {
  final MenuController _controller = Get.put(MenuController());
  int index;
  List<TripWithTemplate> details;
  _DiveResortDetailScreenState(
      int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

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
                detail(this.index, this.details),
              ],
            ),
          ),
        ));
  }
}

class detail extends StatefulWidget {
  int index;
  List<TripWithTemplate> details;
  detail(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
    // print('detail');
    // print(details);
    // print("index");
    // print(index.toString());
  }

  @override
  State<detail> createState() => _detailState(this.index, this.details);
}

class _detailState extends State<detail> {
  int index;
  List<TripWithTemplate> details;
  _detailState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Dive resorts",
          color: Color(0xFFFF78a2cc),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("From : " +
                details[widget.index].fromDate.toDateTime().toString()),
            SizedBox(
              width: 10,
            ),
            Text("From : " +
                details[widget.index].toDate.toDateTime().toString()),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Address : " +
            details[widget.index].tripTemplate.address.addressLine1),
        SizedBox(
          height: 10,
        ),
        Text("Address2 : " +
            details[widget.index].tripTemplate.address.addressLine2),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('City : ' + details[widget.index].tripTemplate.address.city),
            SizedBox(
              width: 20,
            ),
            Text("Country : " +
                details[widget.index].tripTemplate.address.country),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Region : ' +
                details[widget.index].tripTemplate.address.region),
            SizedBox(
              width: 20,
            ),
            Text('Postcode : ' +
                details[widget.index].tripTemplate.address.postcode),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 300,
                height: 300,
                child: details[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(details[widget.index]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 300,
                height: 300,
                child: details[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(details[widget.index]
                        .tripTemplate
                        .images[1]
                        .link
                        .toString())),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 300,
                height: 300,
                child: details[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(details[widget.index]
                        .tripTemplate
                        .images[2]
                        .link
                        .toString())),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Description : " + details[widget.index].tripTemplate.description),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(0xFFFF89cfef),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset("assets/images/S__77242370.jpg"),
                SizedBox(
                  height: 20,
                ),
                Text('Room type : Single Room'),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Room description: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam'),
                SizedBox(
                  height: 20,
                ),
                Text('Max capacity : 5'),
                SizedBox(
                  height: 20,
                ),
                Text('Room quantity : 10'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text('Price : ' + details[widget.index].price.toString()),
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
