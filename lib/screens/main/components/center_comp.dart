import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class CenterCompanySection extends StatefulWidget {
  @override
  State<CenterCompanySection> createState() => _CenterCompanySectionState();
}

class _CenterCompanySectionState extends State<CenterCompanySection> {
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

    user_profile = profile;
    print(user_profile.agency.name);

    return user_profile;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: FutureBuilder(
                future: getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                                'Welcome ' +
                                    user_profile.agency.name +
                                    ' agency',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Text('Welcome');
                  }
                },
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20),
            //   child: Text(
            //     'Plan with us',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            SizedBox(height: 20),
            // MaterialButton(
            //   color: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(20)),
            //   ),
            //   onPressed: () {},
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     child: Text(
            //       'All Detail',
            //       style: TextStyle(color: Colors.green, fontSize: 12),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      constraints: BoxConstraints(maxHeight: 300, minHeight: 100),
      width: double.infinity,
      decoration: BoxDecoration(
          //color: Color(0xfffdcfffb)
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xfffcfecd0),
            Color(0xfffffc5ca),
          ])),
    ));
  }
}
