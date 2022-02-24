import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/diveresort/resort_details_screen.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';

// This list holds the data for the list view
List<LiveAboardData> _foundtrip = [];
List costchecklist = [];
List durationchecklist = [];
List<SearchTripsResponse_Trip> trips = [];

class tripdetail2 extends StatefulWidget {
  _tripdetail2State createState() => _tripdetail2State();
}

class _tripdetail2State extends State<tripdetail2> {
  DateTime _dateTime;
  bool value = false;
  String dropdownValue = 'Onshore';
  String dropdownValue2 = 'Phuket';

  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    costchecklist = [false, false, false, false, false];
    durationchecklist = [false, false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    _foundtrip = LiveAboardDatas;
    // print('candy mai sauy');
    // print(_foundtrip[1].id);
    // print(_foundtrip[2].id);
    // print(_foundtrip[3].id);
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
                Text(
                  "SEARCH",
                  style: TextStyle(fontSize: 20),
                ),
                //TextField(
                //decoration: InputDecoration(
                //border: OutlineInputBorder(),
                //fillColor: Colors.white,
                //hintText: 'From (DD/MM/YY)')),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Start Date'),
                    Spacer(),
                    //  Text(_dateTime == null ? '' : _dateTime.toString()),
                    Spacer(),
                    RaisedButton(
                        color: Color(0xfff8dd9cc),
                        child: Text('Pick a date'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now())
                              .then((date) => {
                                    setState(() {
                                      var timeStamp =
                                          print(Timestamp.fromDateTime(date));
                                      _dateTime = date;
                                    })
                                  });
                        }),
                  ],
                ),
                SizedBox(height: 20),
                //TextField(
                //decoration: InputDecoration(
                //border: OutlineInputBorder(),
                //fillColor: Colors.white,
                // hintText: 'To (DD/MM/YY)')),
                //SizedBox(height: 20),
                //TextField(
                //onChanged: (value) => _runFilter(value),
                //decoration: InputDecoration(
                //border: OutlineInputBorder(),
                //fillColor: Colors.white,
                //hintText: 'Trip Name (Test)')),
                Row(
                  children: [
                    Text('To'),
                    Spacer(),
                    //  Text(_dateTime == null ? '' : _dateTime.toString()),
                    Spacer(),
                    RaisedButton(
                        color: Color(0xfff8dd9cc),
                        child: Text('Pick a date'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now())
                              .then((date) => {
                                    setState(() {
                                      var timeStamp =
                                          print(Timestamp.fromDateTime(date));
                                      _dateTime = date;
                                    })
                                  });
                        }),
                  ],
                ),
                SizedBox(height: 20),
                // TextField(
                //  decoration: InputDecoration(
                //  border: OutlineInputBorder(),
                // fillColor: Colors.white,
                // hintText: 'Location')),
                Text('Location'),
                Container(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: dropdownValue2,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    iconSize: 30,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      _runFilter(newValue);
                      setState(() {
                        dropdownValue2 = newValue;
                      });
                    },
                    items: <String>['Phuket', 'Krabi', 'Samui island', 'Trat']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 20),
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintText: 'Number of customer')),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    iconSize: 30,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Onshore', 'Offshore']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                // TextField(
                //     decoration: InputDecoration(
                //         border: OutlineInputBorder(),
                //         fillColor: Colors.white,
                //         hintText: 'Onshore or offshore')),
                //ElevatedButton(onPressed: () {}, child: Text("SEARCH")),
                SizedBox(height: 20),
                Container(
                    child: Column(children: [
                  Text("Price (per person/trip)"),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ), //SizedBox

                      SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        value: costchecklist[0],
                        onChanged: (bool value) {
                          setState(() {
                            costchecklist[0] = value;
                          });
                        },
                      ), //Checkbox
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
                        value: costchecklist[1],
                        onChanged: (bool value) {
                          setState(() {
                            costchecklist[1] = value;
                          });
                        },
                      ), //Checkbox
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
                        // value: this.value,
                        // onChanged: (bool value) {
                        //   setState(() {
                        //     costchecklist[2] = value;
                        //     this.value = costchecklist[0];
                        //  });
                        value: costchecklist[2],
                        onChanged: (bool value) {
                          setState(() {
                            costchecklist[2] = value;
                          });
                          print(costchecklist);
                        },
                      ), //Checkbox
                      Text(
                        '\$2,001 - \$3,000',
                      ), //Text
                    ], //<Widget>[]
                  ),

                  ///Row
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ), //SizedBox

                      SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        // value: this.value,
                        // onChanged: (bool value) {
                        //   setState(() {
                        //     costchecklist[3] = value;
                        //     this.value = costchecklist[1];
                        //   });
                        value: costchecklist[3],
                        onChanged: (bool value) {
                          setState(() {
                            costchecklist[3] = value;
                          });
                        },
                      ), //Checkbox
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
                        value: costchecklist[4],
                        onChanged: (bool value) {
                          setState(() {
                            costchecklist[4] = value;
                          });
                        },
                      ), //Checkbox
                      Text(
                        'Only special deals',
                      ), //Text
                    ], //<Widget>[]
                  ),
                  SizedBox(height: 20),
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
                        value: durationchecklist[0],
                        onChanged: (bool value) {
                          setState(() {
                            durationchecklist[0] = value;
                          });
                        },
                      ), //Checkbox
                      Text(
                        '1 day',
                      ), //Text
                    ], //<Widget>[]
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ), //SizedBox

                      //SizedBox
                      /** Checkbox Widget **/

                      SizedBox(width: 10),
                      Checkbox(
                        value: durationchecklist[1],
                        onChanged: (bool value) {
                          setState(() {
                            durationchecklist[1] = value;
                          });
                        },
                      ), //Checkbox
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
                        value: durationchecklist[2],
                        onChanged: (bool value) {
                          setState(() {
                            durationchecklist[2] = value;
                          });
                        },
                      ), //Checkbox
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
                        value: durationchecklist[3],
                        onChanged: (bool value) {
                          setState(() {
                            durationchecklist[3] = value;
                          });
                        },
                      ), //Checkbox
                      Text(
                        '8 nights',
                      ), //Text
                    ], //<Widget>[]
                  ),

                  ///Row
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ), //SizedBox

                      SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        value: durationchecklist[4],
                        onChanged: (bool value) {
                          setState(() {
                            durationchecklist[4] = value;
                          });
                        },
                      ), //Checkbox
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
                        value: durationchecklist[5],
                        onChanged: (bool value) {
                          setState(() {
                            durationchecklist[5] = value;
                          });
                        },
                      ), //Checkbox
                      Text(
                        '10 Nights',
                      ), //Text
                    ], //<Widget>[]
                  ),

                  // Text("Diving Intensity"),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: this.value,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           this.value = value;
                  //         });
                  //       },
                  //     ),//Checkbox
                  //     Text(
                  //       '>30 Diving',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: this.value,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           this.value = value;
                  //         });
                  //       },
                  //     ),//Checkbox
                  //     Text(
                  //       '25-30 Diving',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: this.value,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           this.value = value;
                  //         });
                  //       },
                  //     ),//Checkbox
                  //     Text(
                  //       '20-25 Dives',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: this.value,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           this.value = value;
                  //         });
                  //       },
                  //     ),//Checkbox
                  //     Text(
                  //       '15-20 Dives',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: this.value,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           this.value = value;
                  //         });
                  //       },
                  //     ),//Checkbox
                  //     Text(
                  //       '10-15 Dives',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),
                ]))
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
                              _foundtrip.length,
                              (index) => Center(
                                child: InfoCard(
                                  index: index,
                                ),
                              ),
                            ))),
                    // Text(trips[trips.length].diveMasters.toString()),
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

  void _runFilter(String enteredKeyword) {
    var results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = LiveAboardDatas;
    } else {
      results = LiveAboardDatas.where((trip) => trip
          .getname()
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      _foundtrip = results;
    });

    //print(_foundtrip[0].name);
  }
}

class InfoCard extends StatefulWidget {
  InfoCard({
    Key key,
    this.index,
  }) : super(key: key);
  int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  // List<SearchTripsResponse_Trip> trips = [];
  List<SearchTripsResponse_Trip> listTrip;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    //  print('candy');
    print('candy2');
    print(trips.length);
  }

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
    var searchonshore = SearchTripsOptions();
    searchonshore.country = 'Thailand';
    searchonshore.divers = 5;
    var ts = Timestamp();
    ts.seconds = Int64(1643663834);
    searchonshore.startDate = ts;
    var ts2 = Timestamp();
    ts2.seconds = Int64(1645996634);
    searchonshore.endDate = ts2;
    var listonshorerequest = SearchTripsRequest();
    listonshorerequest.limit = Int64(20);
    listonshorerequest.offset = Int64(0);
    listonshorerequest.searchTripsOptions = searchonshore;
    // print(listonshorerequest);
    // stub.searchTrips(listonshorerequest);
    try {
      await for (var feature in stub.searchTrips(listonshorerequest)) {
        // print(feature.trip.price);
        // print(feature.trip.fromDate);
        // print(feature.trip.toDate);
        // print(feature.trip.maxGuest);
        // print(feature.trip.tripTemplate.address.city);
        // print(feature.trip.tripTemplate.images);
        print(feature.trip);
        trips.add(feature.trip);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('---');
    return trips;
    // print(trips.length);
    // print('****');
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return InkWell(
      child: Container(
        height: 320,
        width: 1000,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Container(
            //     width: 300,
            //     height: 300,
            //     child: Image.asset(_foundtrip[widget.index].image)),
            // child: Image.asset(LiveAboardDatas[widget.index].image)),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text('Trip name : ' + _foundtrip[widget.index].name),
                        //LiveAboardDatas[widget.index].name),

                        Text('Location : ' +
                            trips[widget.index].tripTemplate.address.city),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            trips[widget.index].fromDate.toString()),

                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            trips[widget.index].toDate.toString()),
                        SizedBox(
                          height: 10,
                        ),

                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(LiveAboardDatas[widget.index].description),
                        Text('Total people : ' +
                            trips[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),

                        Text('Trip type : ' +
                            trips[widget.index]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                trips[widget.index].price.toString())),
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
