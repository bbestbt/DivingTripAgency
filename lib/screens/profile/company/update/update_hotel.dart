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
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

List<Hotel> hotels = [];

class updateHotel extends StatelessWidget {
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

  getHotel() async {
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
    var listhotelrequest = ListHotelsRequest();

    hotels.clear();
    try {
      await for (var feature in stub.listHotels(listhotelrequest)) {
        hotels.add(feature.hotel);
        // print(trips);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    print('--');
    print(hotels);
    return hotels;
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
          decoration: BoxDecoration(color: Color(0xFFFFfd8be).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Update Hotel",
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
              //           (index) => listHotelCard(
              //             index: index,
              //           ),
              //         ))),
              SizedBox(
                width: 1110,
                child: FutureBuilder(
                  future: getHotel(),
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
                                  hotels.length,
                                  (index) => listHotelCard(
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

class listHotelCard extends StatefulWidget {
  int index;

  listHotelCard(int index) {
    this.index = index;
  }

  @override
  State<listHotelCard> createState() => _listHotelCardState();
}

class _listHotelCardState extends State<listHotelCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(hotels[widget.index].name)),
          ],
        ),
      ),
    );
  }
}
