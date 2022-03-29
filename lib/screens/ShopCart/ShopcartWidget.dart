import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';

List Cartlist = [];
GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class CartWidget extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartWidget> {

    getProfile() async {
    print("before try catch");
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
    return user_profile;
  }

  void bookTrips() async {
    await getProfile();
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = ReservationServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var bookRequest = CreateReservationRequest();
    bookRequest.reservation.diverId = user_profile.diver.id;
    // bookRequest.reservation.price =
    //     roomtypes[widget.index].price * int.parse(_textEditingController.text);
    // bookRequest.reservation.totalDivers =
    //     Int64(roomtypes[widget.index].maxGuest);
    // bookRequest.reservation.tripId = details[widget.index].id;
    // bookRequest.reservation.rooms.add(roomtypes[widget.index]);

    try {
      var response = stub.createReservation(bookRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      ListView.builder(
        itemCount: Cartlist.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Image(
                  image: NetworkImage(
                      'https://media.tacdn.com/media/attractions-splice-spp-674x446/07/2d/d7/09.jpg')),
              SizedBox(width: 30),
              Column(children: [
                Text(
                  "Trip Name: " + Cartlist[position][1].toString(),
                  style: TextStyle(fontSize: 22.0),
                ),
                Text(
                  "Hotel Name: " + Cartlist[position][2].toString(),
                  style: TextStyle(fontSize: 22.0),
                ),
                Text(
                  "Room Name: " + Cartlist[position][3].toString(),
                  style: TextStyle(fontSize: 22.0),
                ),
                Text(
                  "Price: " + Cartlist[position][4].toString(),
                  style: TextStyle(fontSize: 22.0),
                ),
              ]),
              SizedBox(width: 30),
              /*TextButton(
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 25),
                            ),
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                primary: Colors.red,
                                elevation: 2,
                                backgroundColor: Colors.amber),
                          ),*/
              TextButton(
                child: Text(
                  "Remove",
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () {
                  setState(() {
                    print("deleted");

                    Cartlist.removeAt(position);
                    print(Cartlist);
                  });
                },
                style: TextButton.styleFrom(
                    primary: Colors.red,
                    elevation: 2,
                    backgroundColor: Colors.amber),
              ),
            ]),
          ));
        },
      ),
      TextButton(
        child: Text(
          "Go to payment",
          style: TextStyle(fontSize: 25),
        ),
        onPressed: () {},
        style: TextButton.styleFrom(
            primary: Colors.red, elevation: 2, backgroundColor: Colors.amber),
      ),
    ]));

    /*Container(
      color: const Color(0xFFFFE306),
      child: Column(

        children:[
          Text("Shopping Cart"),
        ]
      )
    );*/
  }
}
