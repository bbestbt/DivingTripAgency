import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/profile/company/edit_profile_comp.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';

List<TripWithTemplate> trips = [];
GetProfileResponse user_profile = new GetProfileResponse();
var profile;
Map<String, dynamic> tripMap = {};

class CompanyProfile extends StatefulWidget {
  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  getData() async {
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
    var listTrips = ListTripsWithTemplatesRequest();
    listTrips.limit = Int64(20);
    listTrips.offset = Int64(0);
    trips.clear();
    try {
      //  print('test');
      await for (var feature in stub.listTripsWithTemplates(listTrips)) {
        //print(feature.trip);
        trips.add(feature.trip);
        // print(trips);
        // print(trips.length);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return trips;
  }

  getProfile() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final pf = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    profile = await pf.getProfile(new Empty());
    // print(profile);

    if (profile.hasAgency()) {
      user_profile = profile;
      return user_profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // decoration: BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
      // decoration: BoxDecoration(color: Color(0xfffbbdfbc).withOpacity(0.3)),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          // Icon(
          //   Icons.image,
          //   size: 100,
          // ),
          SectionTitle(
            title: "Profile",
            color: Color(0xFFFF78a2cc),
          ),
          SizedBox(
            height: 20,
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            constraints: BoxConstraints(maxWidth: 1110),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: [
                            SizedBox(
                              child: FutureBuilder(
                                future: getProfile(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue[100],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: PopupMenuButton(
                                                    icon: Icon(
                                                        Icons.more_horiz),
                                                    itemBuilder: (context) =>
                                                        [
                                                          PopupMenuItem(
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .edit),
                                                                Text("Edit"),
                                                              ],
                                                            ),
                                                            value: 1,
                                                          ),
                                                        ],
                                                    onSelected: (int menu) {
                                                      if (menu == 1) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        EditCompanyScreen()));
                                                      }
                                                    }),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'Company name : ' +
                                                    user_profile.agency.name
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'E-mail : ' +
                                                    user_profile
                                                        .agency.account.email
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Phone number : ' +
                                                    user_profile.agency.phone
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Address1 : ' +
                                                    user_profile.agency
                                                        .address.addressLine1
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Address2 : ' +
                                                    user_profile.agency
                                                        .address.addressLine2
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'City : ' +
                                                    user_profile.agency
                                                        .address.city
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Country : ' +
                                                    user_profile.agency
                                                        .address.country
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Region : ' +
                                                    user_profile.agency
                                                        .address.region
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Postal code : ' +
                                                    user_profile.agency
                                                        .address.postcode
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          10,
                                                  height:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          10,
                                                  child: user_profile
                                                              .agency
                                                              .documents
                                                              .length ==
                                                          0
                                                      ? new Container(
                                                          color: Colors.pink,
                                                        )
                                                      : Image.network(
                                                          // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                                                          user_profile
                                                              .agency
                                                              .documents[0]
                                                              .link
                                                              .toString())),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          10,
                                                  height:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          10,
                                                  child: user_profile
                                                              .agency
                                                              .documents
                                                              .length ==
                                                          0
                                                      ? new Container(
                                                          color: Colors.pink,
                                                        )
                                                      : Image.network(
                                                          // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                                                          user_profile
                                                              .agency
                                                              .documents[1]
                                                              .link
                                                              .toString())),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              // Align(
                                              //   alignment: Alignment.center,
                                              //   child: RaisedButton(
                                              //       color: Colors.blue[300],
                                              //       shape: RoundedRectangleBorder(
                                              //           borderRadius:
                                              //               BorderRadius.circular(10)),
                                              //       child: Text(
                                              //         'Edit',
                                              //       ),
                                              //       onPressed: () {
                                              //         Navigator.push(
                                              //             context,
                                              //             MaterialPageRoute(
                                              //                 builder: (context) =>
                                              //                     EditCompanyScreen()));
                                              //       }),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Text('User is not logged in.');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return trips.length != 0
                                ? Column(
                                    children: [
                                      Center(
                                          child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Trip history',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
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
                                                  ))),
                                        ],
                                      )),
                                    ],
                                  )
                                : Text('');
                          } else {
                            return Align(
                                alignment: Alignment.center,
                                child: Text('No data'));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 50,
          ),
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
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 10,
                height: MediaQuery.of(context).size.width / 10,
                child: trips[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(' http://139.59.101.136/static/' +
                            trips[widget.index]
                                .tripTemplate
                                .images[0]
                                .toString()
                        // trips[widget.index].tripTemplate.images[0].toString()
                        )),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Location : ' +
                            trips[widget.index].tripTemplate.address.city),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                trips[widget.index].startDate.toDateTime())),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                trips[widget.index].endDate.toDateTime())),
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
                            child:
                                trips[widget.index].tripRoomTypePrices.length ==
                                        0
                                    ? Text('no price')
                                    : Text('Price : ' +
                                        trips[widget.index]
                                            .tripRoomTypePrices[0]
                                            .price
                                            .toString())),
                        SizedBox(
                          height: 20,
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: RaisedButton(
                        //     onPressed: () {
                        //       //   Navigator.push(
                        //       //       context,
                        //       //       MaterialPageRoute(
                        //       //           builder: (context) =>
                        //       //               DiveResortDetailScreen()));
                        //     },
                        //     color: Colors.amber,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10)),
                        //     child: Text("View package"),
                        //   ),
                        // )
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
