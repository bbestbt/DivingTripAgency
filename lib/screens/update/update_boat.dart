import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/create_boat/create_boat_form.dart';

import 'package:diving_trip_agency/screens/create_trip/create_trip_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/update_boat_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

List<Boat> boats = [];

class updateBoat extends StatelessWidget {
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
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
    // return profile;

    if (profile.hasAgency()) {
      user_profile = profile;
      return user_profile;
    }
  }

  getboat() async {
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
    var listboatrequest = ListBoatsRequest();

    boats.clear();
    try {
      await for (var feature in stub.listBoats(listboatrequest)) {
        boats.add(feature.boat);
        // print(trips);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('--');
    // print(boats);
    return boats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // decoration: BoxDecoration(color: Color(0xFFFFfd8be).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Update Boat",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(
                height: 30,
              ),

              // SizedBox(
              //     width: 1110,
              //     child: Wrap(
              //         spacing: 20,
              //         runSpacing: 40,
              //         children: List.generate(
              //           boats.length,
              //           (index) => listBoatCard(
              //             index: index,
              //           ),
              //         ))),
              SizedBox(
                width: 1110,
                child: FutureBuilder(
                  future: getboat(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                            width: 1110,
                            child: Wrap(
                                spacing: 20,
                                runSpacing: 40,
                                children: List.generate(
                                  boats.length,
                                  (index) => listBoatCard(
                                    index,
                                  ),
                                ))),
                      );
                    } else {
                      return Center(child: Text('User is not logged in'));
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class listBoatCard extends StatefulWidget {
  int index;

  listBoatCard(int index) {
    this.index = index;
  }

  @override
  State<listBoatCard> createState() => _listBoatCardState();
}

class _listBoatCardState extends State<listBoatCard> {
  void removeBoat() async {
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
    var boat = Boat();
    boat.id = boats[widget.index].id;
    var deleteBoatRequest = DeleteDivingBoatRequest();
    deleteBoatRequest.divingBoat = boat;
    try {
      var response = await stub.deleteDivingBoat(deleteBoatRequest);
      print(token);
      print(response);
    } on GrpcError catch (e) {
      // Handle exception of type GrpcError
      print('codeName: ${e.codeName}');
      print('details: ${e.details}');
      print('message: ${e.message}');
      print('rawResponse: ${e.rawResponse}');
      print('trailers: ${e.trailers}');
    } catch (e) {
      // Handle all other exceptions
      print('Exception: $e');
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        await removeBoat();
        print('delete');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => updateBoat()),
          (Route<dynamic> route) => false,
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content:
          Text("Would you like to delete " + boats[widget.index].name + "?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => updateEachBoat(boats[widget.index])));
      // },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
         color: Color(0xfffffdac1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(boats[widget.index].name)),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            Text("Edit"),
                          ],
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            Text("Delete"),
                          ],
                        ),
                        value: 2,
                      )
                    ],
                onSelected: (int menu) {
                  if (menu == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                updateEachBoat(boats[widget.index])));
                  } else if (menu == 2) {
                    showAlertDialog(context);
                  }
                })
            // Container(
            //   width: 30,
            //   height: 30,
            //   child: FloatingActionButton(
            //     backgroundColor: Color(0xffFFA132),
            //     onPressed: () async {
            //       showAlertDialog(context);
            //     },
            //     child: Icon(
            //       Icons.delete,
            //       color: Colors.white,
            //       size: 15,
            //     ),
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
