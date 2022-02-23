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

class TripDetail extends StatefulWidget {
  _TripDetailState createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  DateTime _dateTime;
  bool value = false;
  String dropdownValue = 'Onshore';
  String dropdownValue2 = 'Phuket';

  @override
  initState() {
    // at the beginning, all users are shown
    _foundtrip = LiveAboardDatas;
    super.initState();
    costchecklist = [false, false, false, false, false];
    durationchecklist = [false, false, false, false, false, false];
  }

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
                  child:
                  DropdownButton<String>(
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
                    onChanged: (String newValue){
                      _runFilter(newValue);
                      setState(() {
                        dropdownValue2 = newValue;
                      });
                    },
                    items: <String>['Phuket', 'Krabi','Samui island','Trat']
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
  Map<String, dynamic> hotelTypeMap = {};
  List<String> hotel = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
    var searchonshore = SearchOnshoreTrips();
    searchonshore.city = 'Bangkok';
    searchonshore.divers = 1;
    searchonshore.startDate = Timestamp.fromDateTime(DateTime.now(),);
    searchonshore.endDate = Timestamp.fromDateTime( DateTime(2023));
    var listonshorerequest = SearchOnshoreTripsRequest();
    listonshorerequest.limit=Int64(20);
    listonshorerequest.offset=Int64(0);
    listonshorerequest.searchOnshoreTrips=searchonshore;


    try {
      print('test');
      await for (var feature in stub.searchOnshoreTrips(listonshorerequest)) {
        print('list');
        // print(feature.hotel.name);
        print(feature.trip.price);
        print(feature.trip.fromDate);
        print(feature.trip.toDate);
        print(feature.trip.maxGuest);
        hotel.add((feature.trip.price).toString());
        hotel.add((feature.trip.fromDate).toString());
        hotel.add((feature.trip.toDate).toString());
        hotel.add((feature.trip.maxGuest).toString());
        hotelTypeMap[(feature.trip.price.toString())] = feature.trip.id;
        hotelTypeMap[(feature.trip.fromDate.toString())] = feature.trip.id;
        hotelTypeMap[(feature.trip.toDate.toString())] = feature.trip.id;
        hotelTypeMap[(feature.trip.maxGuest.toString())] = feature.trip.id;
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
                child: Image.asset(_foundtrip[widget.index].image)),
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

                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' + _foundtrip[widget.index].start),

                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' + _foundtrip[widget.index].end),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' + _foundtrip[widget.index].location),
                        SizedBox(
                          height: 10,
                        ),
                        // Text(LiveAboardDatas[widget.index].description),
                        Text(
                            'Total people : ' + _foundtrip[widget.index].total),
                        SizedBox(
                          height: 10,
                        ),

                        Text('Trip type : ' + _foundtrip[widget.index].type),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                'Price : ' + _foundtrip[widget.index].price)),
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
