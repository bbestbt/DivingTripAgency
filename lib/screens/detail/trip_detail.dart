import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbjson.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
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
import 'package:intl/intl.dart';

// This list holds the data for the list view
List<SearchTripsResponse_Trip> _foundtrip = [];
List costchecklist = [];
List durationchecklist = [];

String dropdownValue = "All";
String dropdownValue2 = "All";
int guestvalue;

List<SearchTripsResponse_Trip> trips = [];

class TripDetail extends StatefulWidget {
  _TripDetailState createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  DateTime _dateFrom;
  DateTime _dateTo;
  bool value = false;

  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    // getData();
    costchecklist = [false, false, false, false, false];
    durationchecklist = [false, false, false, false, false, false];

    dropdownValue = 'All';
    dropdownValue2 = 'All';
    _foundtrip = trips;
  }

  getData() async {
    //print("before try catch");
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
    var searchtrips = SearchTripsOptions();
    searchtrips.country = 'm';
    //  searchtrips.city = dropdownValue;
    searchtrips.divers = 5;
    // searchtrips.divers =guestvalue;
    var ts = Timestamp();
    ts.seconds = Int64(1643663834);
    searchtrips.startDate = ts;
    var ts2 = Timestamp();
    // ts2.seconds = Int64(1645996634);
    ts2.seconds = Int64(1648681149);
    searchtrips.endDate = ts2;
    searchtrips.tripType = TripType.OFFSHORE;
    var listtriprequest = SearchTripsRequest();
    listtriprequest.limit = Int64(20);
    listtriprequest.offset = Int64(0);
    listtriprequest.searchTripsOptions = searchtrips;
    trips.clear();
    // print(listonshorerequest);
    // stub.searchTrips(listonshorerequest);
    print(listtriprequest);
    try {
      await for (var feature in stub.searchTrips(listtriprequest)) {
        // print(feature.trip.price);
        // print(feature.trip.fromDate);
        // print(feature.trip.toDate);
        // print(feature.trip.maxGuest);
        // print(feature.trip.tripTemplate.address.city);
        // print(feature.trip.tripTemplate.images);
        //  print(feature.trip);
        trips.add(feature.trip);
        //  print(trips.length);
        // tripMap[feature.trip.toString()] = feature.trip.id;
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
    //   _foundtrip = LiveAboardDatas;
    //   // print('candy mai suay');
    //   // print(_foundtrip[1].id);
    //   // print(_foundtrip[2].id);
    //   // print(_foundtrip[3].id);

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
                Container(
                    width: double.infinity,
                    child: Row(children: [
                      Text(
                        "SEARCH",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _runFilter();
                        },
                        child: const Text('Search'),
                      )
                    ])),

                SizedBox(height: 20),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Start Date'),
                    Spacer(),
                    Text(_dateFrom == null ? '' : _dateFrom.toString()),
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
                                          //  print(Timestamp.fromDateTime(date));
                                          _dateFrom = date;
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
                    Text(_dateTo == null ? '' : _dateTo.toString()),
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
                                          //    print(Timestamp.fromDateTime(date));
                                          _dateTo = date;
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
                Row(
                  children: [
                    Text('Location'),
                    Spacer(),
                    Container(
                      width: 200,
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        iconSize: 30,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'All',
                          'Bangkok',
                          'Phuket',
                          'Krabi',
                          'Samui island',
                          'Trat',
                          'test',
                          'Koh Samet',
                          'Rayong'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Number of customers'),
                    Spacer(),
                    Container(
                      width: 200,
                      height: 30,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          // hintText: 'Number of customer'
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            guestvalue = int.parse(newValue);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Trip Duration (days)'),
                    Spacer(),
                    Container(
                      width: 200,
                      height: 30,
                      child: TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        // hintText: 'Trip Duration (days)'
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Trip type'),
                    Spacer(),
                    Container(
                      width: 200,
                      child: DropdownButton<String>(
                        value: dropdownValue2,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        iconSize: 30,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue2 = newValue;
                          });
                        },
                        items: <String>['All', 'Onshore', 'Offshore']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                // TextField(
                //     decoration: InputDecoration(
                //         border: OutlineInputBorder(),
                //         fillColor: Colors.white,
                //         hintText: 'Onshore or offshore')),
                //ElevatedButton(onPressed: () {}, child: Text("SEARCH")),
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text("Price (per person/trip)")),

                Container(
                    child: Column(children: [
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
                          // print(costchecklist);
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
                  // Text("Trip Duration"),

                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     //SizedBox
                  //     /** Checkbox Widget **/

                  //     SizedBox(width: 10),
                  //     Checkbox(
                  //       value: durationchecklist[0],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           durationchecklist[0] = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //     Text(
                  //       '1 day',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     //SizedBox
                  //     /** Checkbox Widget **/

                  //     SizedBox(width: 10),
                  //     Checkbox(
                  //       value: durationchecklist[1],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           durationchecklist[1] = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //     Text(
                  //       '6 nights',
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
                  //       value: durationchecklist[2],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           durationchecklist[2] = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //     Text(
                  //       '7 nights',
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
                  //       value: durationchecklist[3],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           durationchecklist[3] = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //     Text(
                  //       '8 nights',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),

                  // ///Row
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox

                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: durationchecklist[4],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           durationchecklist[4] = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //     Text(
                  //       '9 nights',
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
                  //       value: durationchecklist[5],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           durationchecklist[5] = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //     Text(
                  //       '10 Nights',
                  //     ), //Text
                  //   ], //<Widget>[]
                  // ),

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
                    // Text(trips.length.toString()),
                    SizedBox(
                      width: 1110,
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // debugPrint(
                            //     'Step 3, build widget: ${snapshot.data}');
                            // Build the widget with data.
                            return Center(
                                child: Container(
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
                                        ))));
                            //Text('hasData: ${snapshot.data}')));
                          } else {
                            // We can show the loading view until the data comes back.
                            // debugPrint('Step 1, build loading widget');
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
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

  void _runFilter() {
    List<SearchTripsResponse_Trip> results = [];
    if (dropdownValue == "All" && _dateFrom == null && _dateTo == null) {
      print("Filtering 1");

      // if the search field is empty or only contains white-space, we'll display all users
      results = trips;
      results[0].tripTemplate.tripType.toString();
      setState(() {
        _foundtrip = results;
      });
    } else
      results = trips;
    if (dropdownValue != "All") {
      print("Filtering 2");
      results = results
          .where(
              (trip) => trip.tripTemplate.address.city.contains(dropdownValue))
          .toList();
    }
    if (_dateFrom != null) {
      results = results
          .where((trip) => trip.fromDate.toDateTime().isAfter(_dateFrom))
          .toList();
    }
    if (_dateTo != null) {
      results = results
          .where((trip) => trip.toDate.toDateTime().isBefore(_dateTo))
          .toList();
    }
    if (guestvalue != null) {
      results = results.where((trip) => trip.maxGuest == guestvalue).toList();
    }
    if (dropdownValue2 != "All") {
      if (dropdownValue2 == "Onshore") {
        results = results
            .where((trip) => trip.tripTemplate.tripType.toString() == "ONSHORE")
            .toList();
      } else {
        results = results
            .where(
                (trip) => trip.tripTemplate.tripType.toString() == "OFFSHORE")
            .toList();
      }
    }

    setState(() {
      _foundtrip = results;
    });
  }

  /*if (_dateFrom != null && _dateTo != null) //if datetimepicker is not null
        {
          if (
              dropdownValue == "All" &&
              guestvalue.isBlank) { //if not filter province

            // if the search field is empty or only contains white-space, we'll display all users
            results = trips.where((trip) =>
            trip.fromDate.toDateTime().isAfter(_dateFrom)
                && trip.toDate.toDateTime().isBefore(_dateTo)).toList();

            setState(() {
              _foundtrip = results;
            });
          }
          else if (dropdownValue != "All")
          { //if filter province
            print("Checking date and place");
            results = trips.where((trip) =>
            trip.fromDate.toDateTime().isAfter(_dateFrom)
                && trip.toDate.toDateTime().isBefore(_dateTo)
                && trip.tripTemplate.address.city.contains(dropdownValue))
                .toList();
            setState(() {
              _foundtrip = results;
            });
          }
          else if (dropdownValue != "All"){
            results = trips.where((trip) =>
            trip.fromDate.toDateTime().isAfter(_dateFrom)
                && trip.toDate.toDateTime().isBefore(_dateTo)
              && trip.tripTemplate.tripType.toString().capitalize == dropdownValue).toList();
          }
          else if (!guestvalue.isBlank && dropdownValue == "All"){
            results = trips.where((trip) =>
            trip.fromDate.toDateTime().isAfter(_dateFrom)
                && trip.toDate.toDateTime().isBefore(_dateTo)

              && trip.maxGuest == guestvalue).toList();
          }*/
  // }
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
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
            Container(
                width: 300,
                height: 300,
                child: _foundtrip[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(
                        // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                        _foundtrip[widget.index]
                            .tripTemplate
                            .images[0]
                            .link
                            .toString()

                        // _foundtrip[widget.index].tripTemplate.images[0].toString()
                        )),
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
                            _foundtrip[widget.index].tripTemplate.address.city),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            _foundtrip[widget.index]
                                .fromDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            _foundtrip[widget.index]
                                .toDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),

                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(LiveAboardDatas[widget.index].description),
                        Text('Total people : ' +
                            _foundtrip[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),

                        Text('Trip type : ' +
                            _foundtrip[widget.index]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                _foundtrip[widget.index].price.toString())),
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
