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

List<GenerateCurrentTripsReportResponse_ReportTrip> trips = [];
// GetProfileResponse user_profile = new GetProfileResponse();
// var profile;
// Map<String, dynamic> tripMap = {};

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
      //  print('test');
      await for (var feature in stub.generateCurrentTripsReport(listvalidtriprequest)) {
        //print(feature.trip);
        trips.add(feature.report);
        print(trips);
        // print(trips.length);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print(trips);
    return trips;
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
                  return CircularProgressIndicator();
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
          // SizedBox(
          //   width: 1110,
          //   child: FutureBuilder(
          //     future: getTrip(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return Center(
          //             child: Container(
          //                 child: Wrap(
          //                     spacing: 20,
          //                     runSpacing: 40,
          //                     children: List.generate(
          //                       trips.length,
          //                       (index) => Center(
          //                         child: InfoCard(
          //                           index: index,
          //                         ),
          //                       ),
          //                     ))));
          //       } else {
          //         return CircularProgressIndicator();
          //       }
          //     },
          //   ),
          // ),
          SizedBox(height: 40,)
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
                            trips[widget.index].endDate.toDateTime().toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            trips[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            trips[widget.index].curentGuest.toString()),
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
                        Text('List of divers : ' + 'd'),
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