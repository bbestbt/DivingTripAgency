import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/diveresort/resort_details_screen.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';

class TripDetail extends StatefulWidget {
  _TripDetailState createState() => _TripDetailState();
}
class _TripDetailState extends State<TripDetail> {
  DateTime _dateTime;
  bool value = false;


  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              height: 1800,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red[50],
              ),
              child: Column(children: [
                Text("SEARCH"),
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintText: 'Date')),
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintText: 'Location')),
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintText: 'Number of customer')),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () {}, child: Text("SEARCH")),
                SizedBox(height: 20),
                Container(
                    child:Column(
                        children:[
                          Text("Price (per person/trip)"),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '\$0 - \$1,000',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '\$1,001 - \$2,000',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '\$2,001 - \$3,000',
                              ), //Text
                            ], //<Widget>[]
                          ),///Row
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '\$3,000+',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                'Only special deals',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          //Trip Duration
                          Text("Trip Duration"),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                               //SizedBox
                              /** Checkbox Widget **/

                              SizedBox(width: 10),
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '6 nights',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '7 nights',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '8 nights',
                              ), //Text
                            ], //<Widget>[]
                          ),///Row
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '9 nights',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '10 Nights',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Text("Diving Intensity"),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '>30 Diving',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '25-30 Diving',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '20-25 Dives',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '15-20 Dives',
                              ), //Text
                            ], //<Widget>[]
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ), //SizedBox

                              SizedBox(width: 10), //SizedBox
                              /** Checkbox Widget **/
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),//Checkbox
                              Text(
                                '10-15 Dives',
                              ), //Text
                            ], //<Widget>[]
                          ),


                        ]
                    )
                )
              ]),
            ),



          ])),
      Expanded(
          flex: 7,
          child: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              child: Container(
                //   margin: EdgeInsetsDirectional.only(top:120),
                width: double.infinity,
                // height: 600,
                decoration:
                    BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
                child: Column(
                  children: [
                    SectionTitle(
                      title: "All Trips",
                      color: Color(0xFFFF78a2cc),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                        width: 1110,
                        child: Wrap(
                            spacing: 20,
                            runSpacing: 40,
                            children: List.generate(
                              LiveAboardDatas.length,
                              (index) => Center(
                                child: InfoCard(
                                  index: index,
                                ),
                              ),
                            ))),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ))
    ]);
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  Map<String, dynamic> hotelTypeMap = {};
  List<String> hotel = [];

  getData() async {
    print("before try catch");
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
    var listonshorerequest = SearchOnshoreTripsRequest();

    try {
      await for (var feature in stub.searchOnshoreTrips(listonshorerequest)) {
        //  print(feature.hotel.name);
        // hotel.add((feature.trip.price).toString());
        // hotelTypeMap[feature.hotel.name] = feature.hotel.id;
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 1000,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
                width: 300,
                height: 300,
                child: Image.asset(LiveAboardDatas[widget.index].image)),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Trip name : ' +
                            LiveAboardDatas[widget.index].name),

                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : '),

                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : '),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : '),
                        SizedBox(
                          height: 10,
                        ),
                        // Text(LiveAboardDatas[widget.index].description),
                        Text('Total people : '),
                        SizedBox(
                          height: 10,
                        ),

                        Text('Trip type : '),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                LiveAboardDatas[widget.index].price)),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            onPressed: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               DiveResortDetailScreen()));
                            },
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("View package"),
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
