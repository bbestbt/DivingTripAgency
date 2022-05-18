import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';

import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/menu_data.dart';
import 'package:diving_trip_agency/screens/update/update_boat.dart';
import 'package:diving_trip_agency/screens/update/update_divemaster.dart';
import 'package:diving_trip_agency/screens/update/update_hotel.dart';
import 'package:diving_trip_agency/screens/update/update_liveaboard.dart';
import 'package:diving_trip_agency/screens/update/update_staff.dart';
import 'package:diving_trip_agency/screens/update/update_trip.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class updateScreen extends StatelessWidget {
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
    return Scaffold(
        endDrawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: CompanyHamburger(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderCompany(),
              Update(),
            ],
          ),
        ));
  }
}

class Update extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // decoration: BoxDecoration(color: Color(0xfffc1bbdd).withOpacity(0.3)),
          child: Column(
            children: [
              SectionTitle(
                title: "Update",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(height: 40),
              // SizedBox(
              //     width: 1110,
              //     child: Wrap(
              //         spacing: 20,
              //         runSpacing: 40,
              //         children: List.generate(
              //           Datas.length,
              //           (index) => InfoCard(
              //             index: index,
              //           ),
              //         ))),

              SizedBox(
                width: 1110,
                child: FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => updateHotel()));
                              },
                              child: Container(
                                height: 200,
                                width: 500,
                                decoration: BoxDecoration(
                                    // color: Color(0xfffc1bbdd).withOpacity(0.3),
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Update hotel",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            updateLiveaboard()));
                              },
                              child: Container(
                                height: 200,
                                width: 500,
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Update liveaboard",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => updateTrip()));
                              },
                              child: Container(
                                height: 200,
                                width: 500,
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Update trip",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => updateBoat()));
                              },
                              child: Container(
                                height: 200,
                                width: 500,
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Update boat",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => updateStaff()));
                              },
                              child: Container(
                                height: 200,
                                width: 500,
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Update staff",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            updateDivemaster()));
                              },
                              child: Container(
                                height: 200,
                                width: 500,
                                decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Update dive master",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: Text('User is not logged in'));
                    }
                  },
                ),
              ),

              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 500,
        decoration: BoxDecoration(
            color: Color(0xfffc1bbdd).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              Datas[widget.index].menu,
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
