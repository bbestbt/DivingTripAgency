import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';

class ListViewTripDetail extends StatefulWidget {
  @override
  _ListViewTripDetailState createState() => _ListViewTripDetailState();
}

class _ListViewTripDetailState extends State<ListViewTripDetail> {
  var nameList = ['Phuket12', 'Samui22', 'Krabi33'];
  var descList = ['description', 'description', 'description'];
  var imgList = [
    'assets/images/S__77242370.jpg',
    'assets/images/S__83271684.jpg',
    'assets/images/S__83271687.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: imgList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                child: Row(children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset(imgList[index]),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nameList[index],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          Text(
                            descList[index],
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   width: width,
                  //   child: Text(
                  //     descList[index],
                  //     style: TextStyle(fontSize: 15),
                  //   ),
                  // )
                ]),
              ),
            );
          }),
    );
  }
}
