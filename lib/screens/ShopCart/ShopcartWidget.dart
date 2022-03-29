import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';

List Cartlist = [];

class CartWidget extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartWidget> {
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
