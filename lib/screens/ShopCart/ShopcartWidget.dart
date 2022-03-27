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

List Cart = ["Trip A", "Trip B", "Trip C"];

class CartWidget extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartWidget> {
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: Cart.length,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children:[
                    Image(image:NetworkImage('https://media.tacdn.com/media/attractions-splice-spp-674x446/07/2d/d7/09.jpg')),
                    SizedBox(width:30),
                    Text(
                    Cart[position],
                    style: TextStyle(fontSize: 22.0),

                    ),
                SizedBox(width:30),
                TextButton(
                  child: Text(
                    "Edit",
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      primary: Colors.red,
                      elevation: 2,
                      backgroundColor: Colors.amber),
                ),
                TextButton(
                  child: Text(
                    "Remove",
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      primary: Colors.red,
                      elevation: 2,
                      backgroundColor: Colors.amber),
                ),
              ]

          ),
        )
        );
      },
    );



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

