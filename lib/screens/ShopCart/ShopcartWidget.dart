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

List<RoomType> roomtypes;
List<TripWithTemplate> details;
int indexRoom;
int indexDetail;
int quantity;
int diver;
GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class CartWidget extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartWidget> {
  @override
  void initState() {
    for (int i = 0; i < Cartlist.length; i++) {
      roomtypes = Cartlist[i][6];
      details = Cartlist[i][5];
      indexRoom = Cartlist[i][7];
      indexDetail = Cartlist[i][8];
      quantity = Cartlist[i][9];
      diver = Cartlist[i][10];
    }
    // TODO: implement initState
    super.initState();
  }

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
    var reservation;

    var room = Reservation_Room();
    for (int i = 0; i < roomtypes.length; i++) {
      room.quantity = quantity;
      room.roomTypeId = roomtypes[i].id;
      room.noDivers = diver;
    }

    reservation = Reservation()..rooms.add(room);
    reservation.tripId = details[indexDetail].id;
    reservation.diverId = user_profile.diver.id;
    reservation.price =
        (roomtypes[indexRoom].price * quantity) + details[indexDetail].price;
    reservation.totalDivers = Int64(roomtypes[indexRoom].maxGuest);

    var bookRequest = CreateReservationRequest()..reservation = reservation;
    try {
      var response = stub.createReservation(bookRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(roomtypes);
    // print(details);
    // print(indexRoom);
    // print(indexDetail);
    // print(quantity);
    // print(diver);
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
                  "Total price: " + Cartlist[position][4].toString(),
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
        SizedBox(height: 30),
      TextButton(
        child: Text(
          "Book",
          style: TextStyle(fontSize: 25),
        ),
        onPressed: () async {
          await bookTrips();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Booking"),
                  content: Text("done"),
                  actions: <Widget>[
                    // FlatButton(
                    //   child: Text("OK"),
                    // ),
                  ],
                );
              });
        },
        style: TextButton.styleFrom(
            primary: Colors.red, elevation: 2, backgroundColor: Colors.amber),
      ),
      SizedBox(height: 30),
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
