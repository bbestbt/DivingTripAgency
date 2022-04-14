import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/screens/create_liveaboard/add_liveaboard_form.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive_flutter/adapters.dart';

class CreateLiveaboardScreen extends StatelessWidget {
  final MenuCompany _controller = Get.put(MenuCompany());
  List<String> errors = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _controller.scaffoldkey,
      drawer: CompanyHamburger(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: 600,
          decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Create Liveaboard",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(
                height: 30,
              ),

              SizedBox(
                width: 1110,
                child: FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: addLiveaboard(this.errors));
                    } else {
                      return Center(child: Text('User is not logged in'));
                    }
                  },
                ),
              ),

              SizedBox(
                height: 30,
              )
              // child: SizedBox(
              //   width: double.infinity,
              //   child: SingleChildScrollView(
              //     child: Container(
              //       height: MediaQuery.of(context).size.height,
              //       width: MediaQuery.of(context).size.width,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               begin: Alignment.topLeft,
              //               end: Alignment.bottomRight,
              //               colors: [
              //             Color(0xfff69b7eb),
              //             Color(0xfffb3dbd3),
              //              Color(0xffff4d6db),
              //           ])),
              //       child: SingleChildScrollView(
              //         child: Column(
              //           children: [
              //             SizedBox(height: 50),
              //             Text(
              //               "Add hotel ",
              //               style: TextStyle(fontSize: 20),
              //             ),
              //             SizedBox(height: 50),
              //             Container(
              //                 width: MediaQuery.of(context).size.width / 1.5,
              //                 decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(10)),
              //                 child: addHotel()),
              //             SizedBox(
              //               height: 30,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
