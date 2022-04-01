import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/trip.pbgrpc.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/profile/company/edit_profile_comp.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

List<ReportTrip> trips = [];
List<ReportTrip> endedTrips = [];
List<Diver> diver = [];
List<Diver> endedDiver = [];
List<ReportTrip> incomingTrips = [];
List<Diver> incomingDiver = [];

class CompanyReport extends StatefulWidget {
  @override
  State<CompanyReport> createState() => _CompanyReportState();
}

class _CompanyReportState extends State<CompanyReport> {
  getValidTrip() async {
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
    var listvalidtriprequest = GenerateCurrentTripsReportRequest();
    listvalidtriprequest.limit = Int64(20);
    listvalidtriprequest.offset = Int64(0);
    trips.clear();
    try {
      await for (var feature
          in stub.generateCurrentTripsReport(listvalidtriprequest)) {
        //print(feature.trip);
        trips.add(feature.report);
        for (int i = 0; i < feature.report.divers.length; i++) {
          diver.add(feature.report.divers[i]);
        }

        // print(trips);
        // print(trips.length);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    print(diver);
    return trips;
  }

  getEndedTrip() async {
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
    var listendedtriprequest = GenerateYearlyEndedTripsReportRequest();
    listendedtriprequest.limit = Int64(20);
    listendedtriprequest.offset = Int64(0);
    endedTrips.clear();
    // print(endedTrips);
    try {
      await for (var feature
          in stub.generateYearlyEndedTripsReport(listendedtriprequest)) {
        // print(feature);
        // print(feature.reports);
        for (int i = 0; i < feature.reports.length; i++) {
          endedTrips.add(feature.reports[i]);
          // print(endedTrips);
          for (int j = 0; j < feature.reports.length; j++) {
            endedDiver.add(feature.reports[i].divers[j]);
          }
        }
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print(endedDiver);
    return endedTrips;
  }

  getIncomingTrip() async {
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
    var listincomingtriprequest = GenerateIncomingTripsReportRequest();
    listincomingtriprequest.limit = Int64(20);
    listincomingtriprequest.offset = Int64(0);
    listincomingtriprequest.weeks = 4;
    incomingTrips.clear();

    try {
      await for (var feature
          in stub.generateIncomingTripsReport(listincomingtriprequest)) {
        incomingTrips.add(feature.report);
        for (int i = 0; i < feature.report.divers.length; i++) {
          incomingDiver.add(feature.report.divers[i]);
        }
      }
    } catch (e) {
      print('ERROR: $e');
    }
    return incomingTrips;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SectionTitle(
            title: "All Trips",
            color: Color(0xFFFF78a2cc),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            constraints: BoxConstraints(maxWidth: 1110),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Incoming Trips',
                  style: TextStyle(fontSize: 20),
                )),
          ),
          SizedBox(
            width: 1110,
            child: FutureBuilder(
              future: getIncomingTrip(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Container(
                          child: Wrap(
                              spacing: 20,
                              runSpacing: 40,
                              children: List.generate(
                                trips.length,
                                (index) => Center(
                                  child: IncomingCard(
                                    index: index,
                                  ),
                                ),
                              ))));
                } else {
                  return Text('No data');
                }
              },
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            constraints: BoxConstraints(maxWidth: 1110),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Trips',
                  style: TextStyle(fontSize: 20),
                )),
          ),
          SizedBox(
            width: 1110,
            child: FutureBuilder(
              future: getValidTrip(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Container(
                          child: Wrap(
                              spacing: 20,
                              runSpacing: 40,
                              children: List.generate(
                                trips.length,
                                (index) => Center(
                                  child: InfoCard(
                                    index: index,
                                  ),
                                ),
                              ))));
                } else {
                  return Text('No data');
                }
              },
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            constraints: BoxConstraints(maxWidth: 1110),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ended trips',
                  style: TextStyle(fontSize: 20),
                )),
          ),
          SizedBox(
            width: 1110,
            child: FutureBuilder(
              future: getEndedTrip(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      // child: Text('test'),
                      child: Container(
                          child: Wrap(
                              spacing: 20,
                              runSpacing: 40,
                              children: List.generate(
                                endedTrips.length,
                                (index) => Center(
                                  child: InfoCardEnded(
                                    index: index,
                                  ),
                                ),
                              ))));
                } else {
                  return Text('No data');
                }
              },
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
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
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
                child: trips[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(trips[widget.index]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Trip name : ' +
                            trips[widget.index].tripTemplate.name),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            trips[widget.index].tripTemplate.address.city +
                            ', ' +
                            trips[widget.index].tripTemplate.address.country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            trips[widget.index]
                                .startDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            trips[widget.index]
                                .endDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            trips[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            trips[widget.index].placesLeft.toString()),
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
                        Text('List of divers'),
                        diver.length == 0
                            ? new Text("No diver")
                            : new Text("Firstname : " +
                                diver[widget.index].firstName +
                                " Lastname : " +
                                diver[widget.index].lastName +
                                "  \nPhone number :" +
                                diver[widget.index].phone +
                                " Level :" +
                                diver[widget.index].level.toString()),
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

class InfoCardEnded extends StatefulWidget {
  InfoCardEnded({
    Key key,
    this.index,
  }) : super(key: key);
  int index;

  @override
  State<InfoCardEnded> createState() => _InfoCardEndedState();
}

class _InfoCardEndedState extends State<InfoCardEnded> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
                child: endedTrips[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(endedTrips[widget.index]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Trip name : ' +
                            endedTrips[widget.index].tripTemplate.name),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            endedTrips[widget.index].tripTemplate.address.city +
                            ', ' +
                            endedTrips[widget.index]
                                .tripTemplate
                                .address
                                .country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            endedTrips[widget.index]
                                .startDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            endedTrips[widget.index]
                                .endDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            endedTrips[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            endedTrips[widget.index].placesLeft.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Trip type : ' +
                            endedTrips[widget.index]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        endedDiver.length == 0
                            ? new Text("No diver")
                            : new Text("List of divers : " +
                                endedDiver[widget.index].firstName +
                                endedDiver[widget.index].lastName),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                endedTrips[widget.index].price.toString())),
                        SizedBox(
                          height: 20,
                        ),
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

class IncomingCard extends StatefulWidget {
  IncomingCard({
    Key key,
    this.index,
  }) : super(key: key);
  int index;

  @override
  State<IncomingCard> createState() => _IncomingCardState();
}

class _IncomingCardState extends State<IncomingCard> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
                child:
                    incomingTrips[widget.index].tripTemplate.images.length == 0
                        ? new Container(
                            color: Colors.pink,
                          )
                        : Image.network(incomingTrips[widget.index]
                            .tripTemplate
                            .images[0]
                            .link
                            .toString())),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Trip name : ' +
                            incomingTrips[widget.index].tripTemplate.name),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            incomingTrips[widget.index]
                                .tripTemplate
                                .address
                                .city +
                            ', ' +
                            incomingTrips[widget.index]
                                .tripTemplate
                                .address
                                .country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            incomingTrips[widget.index]
                                .startDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            incomingTrips[widget.index]
                                .endDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            incomingTrips[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            incomingTrips[widget.index].placesLeft.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Trip type : ' +
                            incomingTrips[widget.index]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        // Text('List of divers : ' + diver[widget.index].firstName),
                        Text('List of divers'),
                        incomingDiver.length == 0
                            ? new Text("No diver")
                            : new Text("Firstname : " +
                                incomingDiver[widget.index].firstName +
                                " Lastname : " +
                                incomingDiver[widget.index].lastName +
                                "  \nPhone number :" +
                                incomingDiver[widget.index].phone +
                                " Level :" +
                                incomingDiver[widget.index].level.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                incomingTrips[widget.index].price.toString())),
                        SizedBox(
                          height: 20,
                        ),
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
