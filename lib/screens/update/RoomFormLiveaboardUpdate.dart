import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addMoreAmenity.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/add_new_amenity_hotel.dart';
//import 'package:diving_trip_agency/screens/update/update_amenity_hotel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'dart:io' as io;

import 'InfoCartLiveaboard.dart';

class RoomFormLiveaboardUpdate extends StatefulWidget {
  List<RoomType> allRoom = [];
  Liveaboard eachLiveaboard;
  final customFunction;
  GlobalKey<AnimatedListState> _key;

  var f2 = File();
  RoomFormLiveaboardUpdate(
      Liveaboard eachLiveaboard, List<RoomType> allRoom, this.customFunction, GlobalKey<AnimatedListState> _key) {
    this.eachLiveaboard = eachLiveaboard;
    this.allRoom = allRoom;
    this._key = _key;
    // print('room'+eachLiveaboard.id.toString());
  }
  @override
  _RoomFormLiveaboardUpdateState createState() =>
      _RoomFormLiveaboardUpdateState(this.eachLiveaboard, this.allRoom, _key);
}

class _RoomFormLiveaboardUpdateState extends State<RoomFormLiveaboardUpdate> {
  List<RoomType> allRoom = [];
  Liveaboard eachLiveaboard;
  GlobalKey<AnimatedListState> _key;

  _RoomFormLiveaboardUpdateState(this.eachLiveaboard, this.allRoom, this._key);
  getRoomType() async {
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
    var listroomrequest = ListRoomTypesRequest();
    listroomrequest.liveaboardId = eachLiveaboard.id;

    allRoom.clear();
    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        allRoom.add(feature.roomType);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('--');
    // print(allRoom);

    return allRoom;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 1110,
      child: FutureBuilder(
        future: getRoomType(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
                spacing: 20,
                runSpacing: 40,
                key: _key,
                children: List.generate(
                  allRoom.length,
                      (index) => InfoCard(
                      index, allRoom, eachLiveaboard, widget.customFunction),
                ));
          } else {
            return Center(child: Text('No room'));
          }
        },
      ),
    );
  }
}